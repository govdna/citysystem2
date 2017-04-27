var echartSkin = (function() {
  var color = [
    ['#5d4c4b','#8f7a79','#9d3631','#b68080','#d9d9d9'],//1
    ['#ca7f28','#e6ad00','#746f5f','#a6a09f','#c6c5c1'],//2
    ['#b27329','#213863','#405889','#7c91ac','#ced7e0'],//3
    ['#b7c1dc','#e9e9e9','#c8dced','#5b8ace','#1a4e8f'],//4
    ['#a29595','#dedede','#d0bbbb','#c40918','#92151c'],//5
    ['#bfbfbf','#56626f','#3e9cde','#8cc7e6','#cfe1eb'],//6
    ['#1e323e','#2c445c','#8595a4','#14a4ac','#d2dadb'],//7
    ['#181e2f','#2c549b','#647595','#869ad9','#c3cee3']//8
  ];
  var skinIndex = $('body').attr('class').replace('skin-', '');
  var colorIndex = color[skinIndex]
  return {
    colorIndex: colorIndex,
  }
})();
