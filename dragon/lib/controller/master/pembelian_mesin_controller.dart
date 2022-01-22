import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dragon/model/master/model_pembelian_mesin.dart';
import 'package:dragon/view/base_widget/toast.dart';

class Pembelian_MesinController with ChangeNotifier {
  List data_pembelianMesinList = [];
  bool proses = false;

  void setProsess(bool proses) {
    this.proses = proses;
  }

  ///paginate
  TextEditingController c_page = new TextEditingController();
  TextEditingController searchController = TextEditingController();
  model_pembelian_mesin m_pembelian_mesin = model_pembelian_mesin();
  List<DropdownMenuItem<int>> dropdownLimit;
  int totalNotaTerima = 0;
  int offset = 0;
  int limit = 50;
  double pageCount = 1;
  int page_index = 0;

  ///paginate
  Future<void> initData() async {
    c_page.text = '1';
    limitPaging();
    await selectDataPaginate(true, '');
    // initFilterSupplier();
  }

  ///paginate
  Future<void> selectDataPaginate(bool reload, String cari) async {
    if (reload) {
      offset = 0;
      page_index = 0;
    }
    data_pembelianMesinList = await m_pembelian_mesin
        .data_pembelian_mesin_paginate(cari, offset, limit);
    var count = await m_pembelian_mesin.count_pembelian_mesin_paginate(cari);
    totalNotaTerima = int.tryParse(count[0]['COUNT(*)'].toString()) ?? 0;
    pageCount = totalNotaTerima / limit;
    notifyListeners();
  }

  ///paginate
  void limitPaging() {
    dropdownLimit = [];
    dropdownLimit.add(DropdownMenuItem(
      child: Text('10'),
      value: 10,
    ));
    dropdownLimit.add(DropdownMenuItem(
      child: Text('25'),
      value: 25,
    ));
    dropdownLimit.add(DropdownMenuItem(
      child: Text('50'),
      value: 50,
    ));
    dropdownLimit.add(DropdownMenuItem(
      child: Text('100'),
      value: 100,
    ));
    limit = dropdownLimit[0].value;
  }

  void selectData(String cari) async {
    offset = 0;
    page_index = 0;
    // await selectDataPaginate(true);
    data_pembelianMesinList = await model_pembelian_mesin()
        .data_pembelian_mesin_paginate(cari, offset, limit);
    var count = await m_pembelian_mesin.count_pembelian_mesin_paginate(cari);
    totalNotaTerima = int.tryParse(count[0]['COUNT(*)'].toString()) ?? 0;
    pageCount = totalNotaTerima / limit;
    notifyListeners();
  }

  //variable tambah mesin
  TextEditingController KD_BHNController = TextEditingController();
  TextEditingController NA_BHNController = TextEditingController();
  TextEditingController SATUANController = TextEditingController();
  TextEditingController AKTIFController = TextEditingController();

  void resetField() {
    KD_BHNController.clear();
    NA_BHNController.clear();
    SATUANController.clear();
    AKTIFController.clear();
  }

  Future<bool> tambah_mesin() async {
    if (KD_BHNController.text.isNotEmpty) {
      BotToast.showLoading();
      Map data_insert = new Map();
      data_insert['NO_ID'] = null;
      data_insert['KD_BHN'] = KD_BHNController.text;
      data_insert['NA_BHN'] = NA_BHNController.text;
      data_insert['SATUAN'] = SATUANController.text;
      data_insert['AKTIF'] = AKTIFController.text;
      await model_pembelian_mesin().insert_data_mesin(data_insert);
      Toast("Success !!", "Berhasil menambah bahan !", true);
      BotToast.closeAllLoading();
      return true;
    } else {
      Toast("Peringatan !", "Silahkan isi semua kolom !", false);
      return false;
    }
  }

  Future<bool> edit_mesin(var id) async {
    if (AKTIFController.text.isNotEmpty) {
      BotToast.showLoading();
      Map data_insert = new Map();
      data_insert['NO_ID'] = id;
      data_insert['KD_BHN'] = KD_BHNController.text;
      data_insert['NA_BHN'] = NA_BHNController.text;
      data_insert['SATUAN'] = SATUANController.text;
      data_insert['AKTIF'] = AKTIFController.text;
      // print(data_insert);
      await model_pembelian_mesin().update_data_mesin_by_id(data_insert);
      Toast("Success !!", "Berhasil update bahan !", true);
      BotToast.closeAllLoading();
      return true;
    } else {
      Toast("Peringatan !", "Silahkan isi semua data !", false);
      return false;
    }
  }

  Future<bool> hapus_mesin(var data) async {
    await model_pembelian_mesin().delete_mesin_byID(data['NO_ID'].toString());
    initData();
  }
}
