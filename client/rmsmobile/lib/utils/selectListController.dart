import 'package:get/get.dart';

class SelectedListController extends GetxController{
  var selectedList = List<String>.empty(growable: true).obs;
  getSelectedList()=>selectedList;
  setSelectedList(List<String> list)=> selectedList.value = list;
}
