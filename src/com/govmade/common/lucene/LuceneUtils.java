package com.govmade.common.lucene;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.tokenattributes.CharTermAttribute;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.LongField;
import org.apache.lucene.document.NumericDocValuesField;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.index.IndexableField;
import org.apache.lucene.index.Term;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.NumericRangeQuery;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.SortField;
import org.apache.lucene.search.SortField.Type;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.search.highlight.Formatter;
import org.apache.lucene.search.highlight.Fragmenter;
import org.apache.lucene.search.highlight.Highlighter;
import org.apache.lucene.search.highlight.InvalidTokenOffsetsException;
import org.apache.lucene.search.highlight.QueryScorer;
import org.apache.lucene.search.highlight.Scorer;
import org.apache.lucene.search.highlight.SimpleFragmenter;
import org.apache.lucene.search.highlight.SimpleHTMLFormatter;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import com.chenlb.mmseg4j.Dictionary;
import com.chenlb.mmseg4j.analysis.ComplexAnalyzer;

/**
 * Lucene工具类(基于Lucene5.0封装)
 * 
 * @author Lanxiaowei
 *
 */

public class LuceneUtils {
	private static final LuceneManager luceneManager = LuceneManager.getInstance();
	public static Analyzer analyzer = new ComplexAnalyzer(System.getProperty("govmade.root") + "/dic/");
	private static LuceneManager manager = LuceneManager.getInstance();
	private static Set<String> docsSet = new HashSet<String>();
	private static StringBuffer sb=new StringBuffer();
	private static int doDocs=0;
	private static int numDocs=0;
	/**
	 * 打开索引目录
	 * 
	 * @param luceneDir
	 * @return
	 * @throws IOException
	 */

	// 重载字典
	public static void reloadDictionary() {
		analyzer = new ComplexAnalyzer(System.getProperty("govmade.root") + "/dic/");
	}

	

	public static FSDirectory openFSDirectory(String luceneDir) {
		FSDirectory directory = null;
		try {
			directory = FSDirectory.open(Paths.get(luceneDir));
			/**
			 * 注意：isLocked方法内部会试图去获取Lock,如果获取到Lock，会关闭它，否则return
			 * false表示索引目录没有被锁， 这也就是为什么unlock方法被从IndexWriter类中移除的原因
			 */
			IndexWriter.isLocked(directory);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return directory;
	}

	/**
	 * 关闭索引目录并销毁
	 * 
	 * @param directory
	 * @throws IOException
	 */
	public static void closeDirectory(Directory directory) throws IOException {
		if (null != directory) {
			directory.close();
			directory = null;
		}
	}

	/**
	 * 获取IndexWriter
	 * 
	 * @param dir
	 * @param config
	 * @return
	 */
	public static IndexWriter getIndexWrtier(Directory dir, IndexWriterConfig config) {
		return luceneManager.getIndexWriter(dir, config);
	}

	/**
	 * 获取IndexWriter
	 * 
	 * @param dir
	 * @param config
	 * @return
	 */
	public static IndexWriter getIndexWrtier(String directoryPath, IndexWriterConfig config) {
		FSDirectory directory = openFSDirectory(directoryPath);
		return luceneManager.getIndexWriter(directory, config);
	}

	/**
	 * 获取IndexReader
	 * 
	 * @param dir
	 * @param enableNRTReader
	 *            是否开启NRTReader
	 * @return
	 */
	public static IndexReader getIndexReader(Directory dir, boolean enableNRTReader) {
		return luceneManager.getIndexReader(dir, enableNRTReader);
	}

	/**
	 * 获取IndexReader(默认不启用NRTReader)
	 * 
	 * @param dir
	 * @return
	 */
	public static IndexReader getIndexReader(Directory dir) {
		return luceneManager.getIndexReader(dir);
	}

	/**
	 * 获取IndexSearcher
	 * 
	 * @param reader
	 *            IndexReader对象
	 * @param executor
	 *            如果你需要开启多线程查询，请提供ExecutorService对象参数
	 * @return
	 */
	public static IndexSearcher getIndexSearcher(IndexReader reader, ExecutorService executor) {
		return luceneManager.getIndexSearcher(reader, executor);
	}

	/**
	 * 获取IndexSearcher(不支持多线程查询)
	 * 
	 * @param reader
	 *            IndexReader对象
	 * @return
	 */
	public static IndexSearcher getIndexSearcher(IndexReader reader) {
		return luceneManager.getIndexSearcher(reader);
	}

	/**
	 * 创建QueryParser对象
	 * 
	 * @param field
	 * @param analyzer
	 * @return
	 */
	public static QueryParser createQueryParser(String field, Analyzer analyzer) {
		return new QueryParser(field, analyzer);
	}

	/**
	 * 关闭IndexReader
	 * 
	 * @param reader
	 */
	public static void closeIndexReader(IndexReader reader) {
		if (null != reader) {
			try {
				System.out.println("closeIndexReader");
				reader.close();
				reader = null;
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * 关闭IndexWriter
	 * 
	 * @param writer
	 */
	public static void closeIndexWriter(IndexWriter writer) {
		if (null != writer) {
			try {
				writer.close();
				writer = null;
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * 关闭IndexReader和IndexWriter
	 * 
	 * @param reader
	 * @param writer
	 */
	public static void closeAll(IndexReader reader, IndexWriter writer) {
		closeIndexReader(reader);
		closeIndexWriter(writer);
	}

	/**
	 * 删除索引[注意：请自己关闭IndexWriter对象]
	 * 
	 * @param writer
	 * @param field
	 * @param value
	 */
	public static void deleteIndex(IndexWriter writer, String field, String value) {
		try {
			writer.deleteDocuments(new Term[] { new Term(field, value) });
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 删除索引[注意：请自己关闭IndexWriter对象]
	 * 
	 * @param writer
	 * @param query
	 */
	public static void deleteIndex(IndexWriter writer, Query query) {
		try {
			writer.deleteDocuments(query);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 批量删除索引[注意：请自己关闭IndexWriter对象]
	 * 
	 * @param writer
	 * @param terms
	 */
	public static void deleteIndexs(IndexWriter writer, Term[] terms) {
		try {
			writer.deleteDocuments(terms);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 批量删除索引[注意：请自己关闭IndexWriter对象]
	 * 
	 * @param writer
	 * @param querys
	 */
	public static void deleteIndexs(IndexWriter writer, Query[] querys) {
		try {
			writer.deleteDocuments(querys);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 删除所有索引文档
	 * 
	 * @param writer
	 */
	public static void deleteAllIndex(IndexWriter writer) {
		try {
			writer.deleteAll();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 更新索引文档
	 * 
	 * @param writer
	 * @param term
	 * @param document
	 */
	public static void updateIndex(IndexWriter writer, Term term, Document document) {
		try {
			writer.updateDocument(term, document);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 更新索引文档
	 * 
	 * @param writer
	 * @param term
	 * @param document
	 */
	public static void updateIndex(IndexWriter writer, String field, String value, Document document) {
		updateIndex(writer, new Term(field, value), document);
	}

	/**
	 * 添加索引文档
	 * 
	 * @param writer
	 * @param doc
	 */
	public static void addIndex(IndexWriter writer, Document document) {
		updateIndex(writer, null, document);
	}

	/**
	 * 索引文档查询
	 * 
	 * @param searcher
	 * @param query
	 * @return
	 */
	public static List<Document> query(IndexSearcher searcher, Query query) {
		TopDocs topDocs = null;
		try {
			topDocs = searcher.search(query, Integer.MAX_VALUE);
			System.out.println("总共匹配多少个：" + topDocs.totalHits);
		} catch (IOException e) {
			e.printStackTrace();
		}
		ScoreDoc[] scores = topDocs.scoreDocs;
		int length = scores.length;
		if (length <= 0) {
			return Collections.emptyList();
		}
		List<Document> docList = new ArrayList<Document>();
		try {
			for (int i = 0; i < length; i++) {

				Document doc = searcher.doc(scores[i].doc);
				System.out.println("匹配得分：" + scores[i].score);
				System.out.println("文档索引ID：" + scores[i].doc);
				System.out.println(doc.getField("path").stringValue());

				docList.add(doc);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return docList;
	}

	/**
	 * 返回索引文档的总数[注意：请自己手动关闭IndexReader]
	 * 
	 * @param reader
	 * @return
	 */
	public static int getIndexTotalCount(IndexReader reader) {
		return reader.numDocs();
	}

	/**
	 * 返回索引文档中最大文档ID[注意：请自己手动关闭IndexReader]
	 * 
	 * @param reader
	 * @return
	 */
	public static int getMaxDocId(IndexReader reader) {
		return reader.maxDoc();
	}

	/**
	 * 返回已经删除尚未提交的文档总数[注意：请自己手动关闭IndexReader]
	 * 
	 * @param reader
	 * @return
	 */
	public static int getDeletedDocNum(IndexReader reader) {
		return getMaxDocId(reader) - getIndexTotalCount(reader);
	}

	/**
	 * 根据docId查询索引文档
	 * 
	 * @param reader
	 *            IndexReader对象
	 * @param docID
	 *            documentId
	 * @param fieldsToLoad
	 *            需要返回的field
	 * @return
	 */
	public static Document findDocumentByDocId(IndexReader reader, int docID, Set<String> fieldsToLoad) {
		try {
			return reader.document(docID, fieldsToLoad);
		} catch (IOException e) {
			return null;
		}
	}

	/**
	 * 根据docId查询索引文档
	 * 
	 * @param reader
	 *            IndexReader对象
	 * @param docID
	 *            documentId
	 * @return
	 */
	public static Document findDocumentByDocId(IndexReader reader, int docID) {
		return findDocumentByDocId(reader, docID, null);
	}

	/**
	 * @Title: createHighlighter
	 * @Description: 创建高亮器
	 * @param query
	 *            索引查询对象
	 * @param prefix
	 *            高亮前缀字符串
	 * @param stuffix
	 *            高亮后缀字符串
	 * @param fragmenterLength
	 *            摘要最大长度
	 * @return
	 */
	public static Highlighter createHighlighter(Query query, String prefix, String stuffix, int fragmenterLength) {
		Formatter formatter = new SimpleHTMLFormatter(
				(prefix == null || prefix.trim().length() == 0) ? "<font color=\"red\">" : prefix,
				(stuffix == null || stuffix.trim().length() == 0) ? "</font>" : stuffix);
		Scorer fragmentScorer = new QueryScorer(query);
		Highlighter highlighter = new Highlighter(formatter, fragmentScorer);
		Fragmenter fragmenter = new SimpleFragmenter(fragmenterLength <= 0 ? 50 : fragmenterLength);
		highlighter.setTextFragmenter(fragmenter);
		return highlighter;
	}

	/**
	 * @Title: highlight
	 * @Description: 生成高亮文本
	 * @param document
	 *            索引文档对象
	 * @param highlighter
	 *            高亮器
	 * @param analyzer
	 *            索引分词器
	 * @param field
	 *            高亮字段
	 * @return
	 * @throws IOException
	 * @throws InvalidTokenOffsetsException
	 */
	public static String highlight(Document document, Highlighter highlighter, Analyzer analyzer, String field)
			throws IOException {
		List<IndexableField> list = document.getFields();
		for (IndexableField fieldable : list) {
			String fieldValue = fieldable.stringValue();
			if (fieldable.name().equals(field)) {
				try {
					int length = fieldValue.length();
					fieldValue = highlighter.getBestFragment(analyzer, field, fieldValue);
					if (fieldValue == null) {
						fieldValue = fieldable.stringValue();
					}

					if (length == fieldValue.length() && fieldValue.length() > 200) {
						fieldValue = fieldValue.substring(0, 200);
					}
					document.removeField(field);
					document.add(new TextField(field, fieldValue, Field.Store.YES));

				} catch (InvalidTokenOffsetsException e) {
					fieldValue = fieldable.stringValue();
				}
				return (fieldValue == null || fieldValue.trim().length() == 0) ? fieldable.stringValue() : fieldValue;
			}
		}
		return null;
	}

	public static String highlight(Document document, Highlighter highlighter, Analyzer analyzer, String[] field)
			throws IOException {
		for (String s : field) {
			highlight(document, highlighter, analyzer, s);
		}
		return null;
	}

	/**
	 * @Title: searchTotalRecord
	 * @Description: 获取符合条件的总记录数
	 * @param query
	 * @return
	 * @throws IOException
	 */
	public static int searchTotalRecord(IndexSearcher search, Query query) {
		ScoreDoc[] docs = null;
		try {
			TopDocs topDocs = search.search(query, Integer.MAX_VALUE);
			if (topDocs == null || topDocs.scoreDocs == null || topDocs.scoreDocs.length == 0) {
				return 0;
			}
			docs = topDocs.scoreDocs;
		} catch (IOException e) {
			e.printStackTrace();
		}
		return docs.length;
	}

	public static int searchTotalRecord(IndexSearcher search, Query query, Page<Document> page) {
		ScoreDoc[] docs = null;
		try {
			TopDocs topDocs = search.search(query, Integer.MAX_VALUE);
			if (topDocs == null || topDocs.scoreDocs == null || topDocs.scoreDocs.length == 0) {
				return 0;
			}
			docs = topDocs.scoreDocs;
		} catch (IOException e) {
			e.printStackTrace();
		}
		page.setTotalRecord(docs.length);
		int index = (page.getCurrentPage() - 1) * page.getPageSize();
		if (docs.length > index && index > 0) {
			page.setAfterDoc(docs[index - 1]);
		}
		return docs.length;
	}

	/**
	 * @Title: pageQuery
	 * @Description: Lucene分页查询
	 * @param searcher
	 * @param query
	 * @param page
	 * @throws IOException
	 */
	public static void pageQuery(IndexSearcher searcher, Directory directory, Query query, Page<Document> page) {
		int totalRecord = searchTotalRecord(searcher, query);
		// 设置总记录数
		page.setTotalRecord(totalRecord);
		TopDocs topDocs = null;
		try {
			topDocs = searcher.searchAfter(page.getAfterDoc(), query, page.getPageSize());
		} catch (IOException e) {
			e.printStackTrace();
		}
		List<Document> docList = new ArrayList<Document>();
		ScoreDoc[] docs = topDocs.scoreDocs;
		int index = 0;
		for (ScoreDoc scoreDoc : docs) {
			int docID = scoreDoc.doc;
			Document document = null;
			try {
				document = searcher.doc(docID);
			} catch (IOException e) {
				e.printStackTrace();
			}
			if (index == docs.length - 1) {
				page.setAfterDoc(scoreDoc);
				page.setAfterDocId(docID);
			}
			docList.add(document);
			index++;
		}
		page.setItems(docList);
		closeIndexReader(searcher.getIndexReader());
	}

	/**
	 * @Title: pageQuery
	 * @Description: 分页查询[如果设置了高亮,则会更新索引文档]
	 * @param searcher
	 * @param directory
	 * @param query
	 * @param page
	 * @param highlighterParam
	 * @param writerConfig
	 * @throws IOException
	 */
	public static void pageQuery(Analyzer analyzer, IndexSearcher searcher, Directory directory, Query query,
			Page<Document> page, HighlighterParam highlighterParam, IndexWriterConfig writerConfig) throws IOException {
		IndexWriter writer = null;
		// 若未设置高亮
		if (null == highlighterParam || !highlighterParam.isHighlight()) {
			pageQuery(searcher, directory, query, page);
		} else {
			int totalRecord = searchTotalRecord(searcher, query, page);
			if (totalRecord < (page.getCurrentPage() - 1) * page.getPageSize()) {
				return;
			}
			TopDocs topDocs = searcher.searchAfter(page.getAfterDoc(), query, page.getPageSize());
			// 按时间排序
			// TopDocs topDocs = searcher.searchAfter(page.getAfterDoc(), query,
			// page.getPageSize(),new Sort(new SortField("modified",
			// Type.LONG,true)));

			List<Document> docList = new ArrayList<Document>();
			ScoreDoc[] docs = topDocs.scoreDocs;
			int index = 0;
			writer = getIndexWrtier(directory, writerConfig);
			for (ScoreDoc scoreDoc : docs) {
				int docID = scoreDoc.doc;
				Document document = searcher.doc(docID);

				Highlighter highlighter = LuceneUtils.createHighlighter(query, highlighterParam.getPrefix(),
						highlighterParam.getStuffix(), highlighterParam.getFragmenterLength());
				highlight(document, highlighter, analyzer, highlighterParam.getFieldName());
				if (index == docs.length - 1) {
					page.setAfterDoc(scoreDoc);
					page.setAfterDocId(docID);
				}
				docList.add(document);
				index++;
			}
			page.setItems(docList);
		}
		closeIndexReader(searcher.getIndexReader());
		closeIndexWriter(writer);
	}

	// 如果索引为空，建立索引
	public static void init() {
		File file = new File(LuceneConfig.getLucenePath());
		if (file.isDirectory() && file.list().length == 0) {
			try {
				System.out.println("start");
				long start = System.currentTimeMillis();
				Directory dir = FSDirectory.open(Paths.get(LuceneConfig.getLucenePath(), new String[0]));
				Path docDirPath = Paths.get(LuceneConfig.getDocPath(), new String[0]);
				// Analyzer analyzer = new AnsjAnalyzer();
				IndexWriterConfig indexWriterConfig = new IndexWriterConfig(analyzer);
				indexWriterConfig.setOpenMode(IndexWriterConfig.OpenMode.CREATE_OR_APPEND);
				IndexWriter writer = manager.getIndexWriter(dir, indexWriterConfig);
//				SearchContext con = new SearchContext();
//				con.setSearchClass(GovmadeFile.class);
//				List<GovmadeFile> files = (List) fileService.getBizObjListFull(con, "");
//				DocParameter parameter = new DocParameter();
//				parameter.setMode(DocParameter.RECOVER_MODE);
//				for (GovmadeFile f : files) {
//					parameter.setLastModified(
//							Files.getLastModifiedTime(Paths.get(f.getRealPath(), new String[0]), new LinkOption[0])
//									.toMillis());
//					parameter.setFileId(f.getId());
//					parameter.setResourceId(f.getResourceId());
//					parameter.setResourceType(f.getResourceType());
//					indexDoc(writer, Paths.get(f.getRealPath()), parameter);
//				}
				writer.close();
				long end = System.currentTimeMillis();
				System.out.println("Time consumed:" + (end - start) + " ms");

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * 创建索引
	 * 
	 * @param dirPath
	 *            需要读取的文件所在文件目录
	 * @param indexPath
	 *            索引存放目录
	 * @throws IOException
	 */
	// public static void createIndex(String dirPath, String indexPath) throws
	// Exception {
	// createIndex(dirPath, indexPath, false);
	// }

	/**
	 * 创建索引
	 * 
	 * @param dirPath
	 *            需要读取的文件所在文件目录
	 * @param indexPath
	 *            索引存放目录
	 * @param createOrAppend
	 *            始终重建索引/不存在则追加索引
	 * @throws Exception
	 */
	// public static void createIndex(String dirPath, String indexPath, boolean
	// createOrAppend) throws Exception {
	// long start = System.currentTimeMillis();
	// Directory dir = FSDirectory.open(Paths.get(indexPath, new String[0]));
	// Path docDirPath = Paths.get(dirPath, new String[0]);
	// // Analyzer analyzer = new AnsjAnalyzer();
	// IndexWriterConfig indexWriterConfig = new IndexWriterConfig(analyzer);
	//
	// if (createOrAppend) {
	// indexWriterConfig.setOpenMode(IndexWriterConfig.OpenMode.CREATE);
	// } else {
	// indexWriterConfig.setOpenMode(IndexWriterConfig.OpenMode.CREATE_OR_APPEND);
	// }
	// IndexWriter writer =manager.getIndexWriter(dir, indexWriterConfig);
	// indexDocs(writer, docDirPath);
	// writer.close();
	// long end = System.currentTimeMillis();
	// System.out.println("Time consumed:" + (end - start) + " ms");
	//
	// }

	public static void createIndex(String dirPath, String indexPath, DocParameter parameter) throws Exception {
		long start = System.currentTimeMillis();
		Directory dir = FSDirectory.open(Paths.get(indexPath, new String[0]));
		Path docDirPath = Paths.get(dirPath, new String[0]);
		// Analyzer analyzer = new AnsjAnalyzer();
		IndexWriterConfig indexWriterConfig = new IndexWriterConfig(analyzer);

		if (parameter.isCreateOrAppend()) {
			indexWriterConfig.setOpenMode(IndexWriterConfig.OpenMode.CREATE);
		} else {
			indexWriterConfig.setOpenMode(IndexWriterConfig.OpenMode.CREATE_OR_APPEND);
		}
		IndexWriter writer = manager.getIndexWriter(dir, indexWriterConfig);
		docsSet.add(dirPath);
		indexDocs(writer, docDirPath, parameter);
		docsSet.remove(dirPath);
		// 解决多线程问题
		if (docsSet.size() == 0) {
			System.out.println("-------close writer-------");
			writer.close();
		}
		long end = System.currentTimeMillis();
		System.out.println("Time consumed:" + (end - start) + " ms");

	}

	// public static void createIndex(String dirPath, boolean
	// createOrAppend,Integer id) throws Exception {
	//
	// try {
	// long start = System.currentTimeMillis();
	// Directory dir = FSDirectory.open(Paths.get(LuceneConfig.getLucenePath(),
	// new String[0]));
	// Path docDirPath = Paths.get(dirPath, new String[0]);
	// // Analyzer analyzer = new AnsjAnalyzer();
	// IndexWriterConfig indexWriterConfig = new IndexWriterConfig(analyzer);
	// indexWriterConfig.setOpenMode(IndexWriterConfig.OpenMode.CREATE_OR_APPEND);
	// IndexWriter writer =manager.getIndexWriter(dir, indexWriterConfig);
	// indexDocRe(writer,docDirPath, Files.getLastModifiedTime(docDirPath, new
	// LinkOption[0]).toMillis(),id);
	// writer.close();
	// long end = System.currentTimeMillis();
	// System.out.println("Time consumed:" + (end - start) + " ms");
	//
	// } catch (Exception e) {
	// e.printStackTrace();
	// }
	// }
	/**
	 * 
	 * @param writer
	 *            索引写入器
	 * @param path
	 *            文件路径
	 * @throws IOException
	 */
	// public static void indexDocs(final IndexWriter writer, Path path) throws
	// Exception {
	// // 如果是目录，查找目录下的文件
	// if (Files.isDirectory(path, new LinkOption[0])) {
	// System.out.println("directory");
	// Files.walkFileTree(path, new SimpleFileVisitor() {
	// @Override
	// public FileVisitResult visitFile(Object file, BasicFileAttributes attrs)
	// throws IOException {
	// Path path = (Path) file;
	// System.out.println(path.getFileName());
	// try {
	// indexDoc(writer, path, attrs.lastModifiedTime().toMillis());
	// } catch (Exception e) {
	// // TODO Auto-generated catch block
	// e.printStackTrace();
	// }
	// return FileVisitResult.CONTINUE;
	// }
	// });
	// } else {
	// indexDoc(writer, path, Files.getLastModifiedTime(path, new
	// LinkOption[0]).toMillis());
	// }
	// }

	public static void indexDocs(final IndexWriter writer, Path path, final DocParameter parameter) throws Exception {
		// 如果是目录，查找目录下的文件
		if (Files.isDirectory(path, new LinkOption[0])) {
			System.out.println("directory");
			Files.walkFileTree(path, new SimpleFileVisitor() {
				@Override
				public FileVisitResult visitFile(Object file, BasicFileAttributes attrs) throws IOException {
					Path path = (Path) file;
					System.out.println(path.getFileName());
					try {
						parameter.setLastModified(attrs.lastModifiedTime().toMillis());
						indexDoc(writer, path, parameter);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					return FileVisitResult.CONTINUE;
				}
			});
		} else {
			parameter.setLastModified(Files.getLastModifiedTime(path, new LinkOption[0]).toMillis());

			indexDoc(writer, path, parameter);
		}
	}

	

	public static void indexDoc(IndexWriter writer, Path file, DocParameter parameter) throws Exception {

		Document doc = new Document();
		File f = file.toFile();
		Field pathField = new StringField("path", f.getAbsolutePath(), Field.Store.YES);
		doc.add(pathField);
		doc.add(new TextField("fileName", f.getName(), Field.Store.YES));
		doc.add(new StringField("id", parameter.getFile().getId() + "", Field.Store.YES));
		doc.add(new StringField("informationResourceId", parameter.getFile().getInformationResourceId() + "", Field.Store.YES));
		doc.add(new NumericDocValuesField("modified", parameter.getLastModified()));
		doc.add(new NumericDocValuesField("addDate", System.currentTimeMillis()));
		doc.add(new LongField("modified", parameter.getLastModified(), Field.Store.YES));
		doc.add(new LongField("addDate", System.currentTimeMillis(), Field.Store.YES));

		if (!addContextToDoc(doc, f)) {
			return;
		}
		if (writer.getConfig().getOpenMode() == IndexWriterConfig.OpenMode.CREATE) {
			System.out.println("adding " + file);
			writer.addDocument(doc);
		} else {
			System.out.println("updating " + file);
			writer.updateDocument(new Term("path", file.toString()), doc);
		}
		writer.commit();
	}

	

	private static boolean addContextToDoc(Document doc, File f) throws Exception {
		if (f.getName().toLowerCase().endsWith("docx") || f.getName().toLowerCase().endsWith("docm")) {
			doc.add(new TextField("content", ReadFile.readWord2007(f.getAbsolutePath()), Field.Store.YES));
			doc.add(new StringField("type", "doc", Field.Store.YES));
		} else if (f.getName().toLowerCase().endsWith("doc")) {
			doc.add(new TextField("content", ReadFile.readWord(f.getAbsolutePath()), Field.Store.YES));
			doc.add(new StringField("type", "doc", Field.Store.YES));
		} else if (f.getName().toLowerCase().endsWith("xls")) {
			doc.add(new TextField("content", ReadFile.ReadExcel(f.getAbsolutePath()), Field.Store.YES));
			doc.add(new StringField("type", "xls", Field.Store.YES));
		} else if (f.getName().toLowerCase().endsWith("xlsx")) {
			doc.add(new TextField("content", ReadFile.readExcel2007(f.getAbsolutePath()), Field.Store.YES));
			doc.add(new StringField("type", "xls", Field.Store.YES));
		} else if (f.getName().toLowerCase().endsWith("pdf")) {
			doc.add(new TextField("content", ReadFile.readPdf(f.getAbsolutePath()), Field.Store.YES));
			doc.add(new StringField("type", "pdf", Field.Store.YES));
		} else if (f.getName().toLowerCase().endsWith("ppt")) {
			doc.add(new TextField("content", ReadFile.readPPT(f.getAbsolutePath()), Field.Store.YES));
			doc.add(new StringField("type", "ppt", Field.Store.YES));
		} else if (f.getName().toLowerCase().endsWith("pptx")) {
			doc.add(new TextField("content", ReadFile.readPPT2007(f.getAbsolutePath()), Field.Store.YES));
			doc.add(new StringField("type", "ppt", Field.Store.YES));
		} else if (f.getName().toLowerCase().endsWith("txt")) {
			String fileCode = codeStringPlus(f.getAbsolutePath());
			doc.add(new StringField("type", "txt", Field.Store.YES));
			doc.add(new TextField("content", ReadFile.readTxt(f.getAbsolutePath(), fileCode), Field.Store.YES));
		} else {
			return false;
		}

		return true;
	}

	/**
	 * 删除索引
	 * 
	 * @param str
	 *            删除的关键字
	 * @throws Exception
	 */
	public static void deleteById(Integer id) throws Exception {
		if (id != null) {
			Directory dir = FSDirectory.open(Paths.get(LuceneConfig.getLucenePath(), new String[0]));
			IndexWriter writer = getIndexWrtier(dir, new IndexWriterConfig(analyzer));
			writer.deleteDocuments(new Term("id", id + ""));
			writer.close();
		}
	}

	public static void deleteByResourceId(Integer id, Integer type) throws Exception {
		if (id != null) {
			Directory dir = FSDirectory.open(Paths.get(LuceneConfig.getLucenePath(), new String[0]));
			IndexWriter writer = getIndexWrtier(dir, new IndexWriterConfig(analyzer));
			writer.deleteDocuments(new Term("typeCode", DocParameter.getTypeCode(type) + id));
			writer.commit();
			writer.close();
		}
	}

	public static void deleteByFileId(Integer id) throws Exception {
		if (id != null) {
			Directory dir = FSDirectory.open(Paths.get(LuceneConfig.getLucenePath(), new String[0]));
			IndexWriter writer = getIndexWrtier(dir, new IndexWriterConfig(analyzer));
			writer.deleteDocuments(new Term("id", id + ""));
			writer.commit();
			writer.close();
		}
	}

	public static int getNumDocs() throws Exception {
		Directory dir = FSDirectory.open(Paths.get(LuceneConfig.getLucenePath(), new String[0]));
		IndexReader reader = getIndexReader(dir);
		int num = 0;
		if (reader != null) {
			// 通过reader可以有效的获取到文档的数量
			num = reader.numDocs();
			closeIndexReader(reader);
		}
		return num;
	}

	public static Document getDocumentById(Integer id) throws IOException {
		Directory dir = FSDirectory.open(Paths.get(LuceneConfig.getLucenePath(), new String[0]));
		Query query = NumericRangeQuery.newIntRange("id", id, id, true, true);
		// LuceneUtils.pageQuery(analyzer,new
		// IndexSearcher((DirectoryReader.open(dir))),dir,tquery,null,null,new
		// IndexWriterConfig(analyzer));
		IndexSearcher searcher = new IndexSearcher((DirectoryReader.open(dir)));
		ScoreDoc[] hits = searcher.search(query, 1).scoreDocs;
		if (hits.length > 0) {
			return searcher.doc(hits[0].doc);
		}
		return null;
	}

	public static String readFileContent(File file) {
		try {
			BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(file)));
			StringBuffer content = new StringBuffer();

			for (String line = null; (line = reader.readLine()) != null;) {
				content.append(line).append("\n");
			}
			return content.toString();
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	public static String codeStringPlus(String fileName) throws Exception {
		BufferedInputStream bin = null;
		String code = null;

		try {
			bin = new BufferedInputStream(new FileInputStream(fileName));
			int p = (bin.read() << 8) + bin.read();
			switch (p) {
			case 0xefbb:
				code = "UTF-8";
				break;
			case 0xfffe:
				code = "Unicode";
				break;
			case 0xfeff:
				code = "UTF-16BE";
				break;
			default:
				code = "GBK";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			bin.close();
		}

		return code;
	}

	public static List<String> getWords(String str, Analyzer analyzer) {
		List<String> result = new ArrayList<String>();
		TokenStream stream = null;
		try {
			stream = analyzer.tokenStream("contents", new StringReader(str));
			CharTermAttribute attr = stream.addAttribute(CharTermAttribute.class);
			stream.reset();
			while (stream.incrementToken()) {
				result.add(attr.toString());
			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (stream != null) {
				try {
					stream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return result;
	}

}
