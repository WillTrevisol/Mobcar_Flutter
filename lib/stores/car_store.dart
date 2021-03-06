import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/car.dart';
import '../models/car_brand.dart';
import '../models/car_model.dart';
import '../models/car_year.dart';
part 'car_store.g.dart';

// ignore: library_private_types_in_public_api
class CarStore = _CarStoreBase with _$CarStore;

const carsKey = 'carList';

abstract class _CarStoreBase with Store {
  
  late SharedPreferences sharedPreferences;

  _CarStoreBase() {
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
  }
  
  @observable
  ObservableList<CarBrand> brands = ObservableList<CarBrand>();

  @action
  void addBrands(List<CarBrand> data) {
    brands.addAll(data);
  }

  @observable
  CarBrand? carBrand;

  @action
  void setCarBrand(CarBrand? value) => carBrand = value;

  @observable
  String? brandCode;

  @action
  void setBrandCode(String? value) => brandCode = value;

  @observable
  ObservableList<CarModel> models = ObservableList<CarModel>();

  @action
  void addModels(List<CarModel> data) {
    models.clear();
    years.clear();
    carYear = null;
    carModel = null;
    models.addAll(data);
  }

  @observable
  CarModel? carModel;

  @action
  void setCarModel(CarModel value) => carModel = value;

  @observable
  int? modelCode;

  @action
  void setModelCode(int? value) => modelCode = value; 

  @observable
  ObservableList<CarYear> years = ObservableList<CarYear>();

  @action
  void addYears(List<CarYear> data) {
    years.clear();
    carYear = null;
    years.addAll(data);
  }

  @observable
  CarYear? carYear;

  @action
  void setCarYear(CarYear? value) => carYear = value;

  @observable
  String? yearCode;

  @action
  void setYearCode(String? value) => yearCode = value;

  @observable
  Car? car;

  @action
  void setCar(Car value) => car = value;

  @observable
  ObservableList<Car> cars = ObservableList<Car>();

  @action
  void addCar() {
    cars.add(car!);
  }

  @action
  Future<void> removeCar(Car car) async {
    cars.remove(car);
    saveList();
  }

  @action
  void saveList() async {
    final carsListJson = jsonEncode(cars);
    sharedPreferences.setString(carsKey, carsListJson);
  }

  @action
  Future<void> getCarsList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final jsonString = sharedPreferences.getString(carsKey) ?? '[]';
    final List jsonDecoded = jsonDecode(jsonString);
    cars.addAll(jsonDecoded.map((e) => Car.fromJson(e)).toList());
  }

  @action
  void clearFields() {
    brands.clear();
    carBrand = null;
    brandCode = null;
    models.clear();
    carModel = null;
    modelCode = null;
    years.clear();
    carYear = null;
    yearCode = null;
  }
  
} 