import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/features/auth/data/models/auth_hive_model.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  //Get batch box
  Box<BatchHiveModel> get _batchBox =>
      Hive.box<BatchHiveModel>(HiveTableConstant.batchTable);

  //Create a new batch
  Future<BatchHiveModel> createBatch(BatchHiveModel batch) async {
    await _batchBox.put(batch.batchId, batch);
    return batch;
  }

  //Get all batches
  Future<List<BatchHiveModel>> getAllBatches() async {
    return _batchBox.values.toList();
  }

  //Get batch by ID
  BatchHiveModel? getBatchById(String batchId) {
    return _batchBox.get(batchId);
  }

  //Update a batch
  Future<void> updateBatch(BatchHiveModel batch) async {
    await _batchBox.put(batch.batchId, batch);
  }

  //Delete a batch
  Future<void> deleteBatch(String batchId) async {
    await _batchBox.delete(batchId);
  }

  //Initialize Hive
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
    _registerAdapters();
    await openBoxes();
    await insertDummybatches();
  }

  Future<void> insertDummybatches() async {
    final box = Hive.box<BatchHiveModel>(HiveTableConstant.batchTable);
    if (box.isNotEmpty) return;
    
    final dummyBatches = [
      BatchHiveModel(batchName: '35-A'),
      BatchHiveModel(batchName: '35-B'),
      BatchHiveModel(batchName: '35-C'),
      BatchHiveModel(batchName: '36-B'),
      BatchHiveModel(batchName: '37-C'),
    ];
    for (var batch in dummyBatches) {
      await box.put(batch.batchId, batch);
    }
    await box.close();
  }

  //Register all type adapters
  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.batchTypeId)) {
      Hive.registerAdapter(BatchHiveModelAdapter());
    }

    //Register other adapter here
    if(!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)){
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
  }

  //Open all boxes
  Future<void> openBoxes() async {
    await Hive.openBox<BatchHiveModel>(HiveTableConstant.batchTable);
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
  }

  //Delete all batches
  Future<void> deleteAllBatches() async {
    await _batchBox.clear();
  }

  //Close all boxes
  Future<void> close() async {
    await Hive.close();
  }
  //======================Auth Queries===========
  Box <AuthHiveModel> get _authBox =>
  Hive.box<AuthHiveModel>(HiveTableConstant.authTable);


  Future<AuthHiveModel>registerUser(AuthHiveModel model)async{
    await _authBox.put(model.authId, model);
    return model;
  }
  //Login User
  Future<AuthHiveModel?> loginUser (String email, String password) async {
    final users = _authBox.values.where(
      (user) => user.email == email && user.password ==password,
    );
    if (users.isNotEmpty){
      return users.first;
    }
    return null;
  }
  //Logout

  Future<void>logoutUser()async{}

  //get current user
  AuthHiveModel? getCurrentUser(String authId){
    return _authBox.get(authId);
  }

// is email exists

bool isEmailExits(String email) {
  final users = _authBox.values.where((user)=>user.email == email);
  return users.isNotEmpty;
}



}