package com.govmade.entity.system.theme;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;

/**   
* @author (作者) Chenlei 774329191@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月28日 上午10:02:19   
* @Title: Theme.java  
*/
@Alias("Theme")
public class Theme extends IdBaseEntity{
	
    /**
	 * 
	 */
	private static final long serialVersionUID = -2152671618831398510L;

	private Integer themeType; // 主题类型
	
	private String logoBig; // 大logo
	
	private Integer logoSmall; // 小logo
	
	private String titleBig; // 大标题
	
	private String titleSmall; // 小标题
	
	private String belongType; //1:风格2：模块
	
	private Integer tColor; //色系

	public Integer gettColor() {
		return tColor;
	}

	public void settColor(Integer tColor) {
		this.tColor = tColor;
	}

	public String getBelongType() {
		return belongType;
	}

	public void setBelongType(String belongType) {
		this.belongType = belongType;
	}

	public Integer getThemeType() {
		return themeType;
	}

	public void setThemeType(Integer themeType) {
		this.themeType = themeType;
	}

	public String getLogoBig() {
		return logoBig;
	}

	public void setLogoBig(String logoBig) {
		this.logoBig = logoBig;
	}

	public Integer getLogoSmall() {
		return logoSmall;
	}

	public void setLogoSmall(Integer logoSmall) {
		this.logoSmall = logoSmall;
	}

	public String getTitleBig() {
		return titleBig;
	}

	public void setTitleBig(String titleBig) {
		this.titleBig = titleBig;
	}

	public String getTitleSmall() {
		return titleSmall;
	}

	public void setTitleSmall(String titleSmall) {
		this.titleSmall = titleSmall;
	}

}
