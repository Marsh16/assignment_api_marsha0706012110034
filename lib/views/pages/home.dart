part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Costs> costsData = [];
  List<Province> provinceData = [];
  bool isLoading = false;

  String selectedCourier = 'jne'; 
  String weightInput = ''; 

  dynamic cityDataOrigin;
  dynamic cityIdOrigin;
  dynamic selectedCityOrigin;

  dynamic cityDataDestination;
  dynamic cityIdDestination;
  dynamic selectedCityDestination;

  dynamic provinceIdDestination;
  dynamic selectedProvinceDestination;

  dynamic provinceIdOrigin;
  dynamic selectedProvinceOrigin;

  Future<dynamic> getProvinces() async {
    await MasterDataService.getProvince().then((value) {
      setState(() {
        provinceData = value;
        isLoading = false;
      });
    });
  }

  Future<List<City>> getCities(var provId) async {
    dynamic city;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        city = value;
      });
    });
    return city;
  }

  Future<dynamic> getCosts(
      var originId, var destinationId, var weight, var courier) async {
    await MasterDataService.getCosts(originId, destinationId, weight, courier)
        .then((value) {
      setState(() {
        costsData = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Hitung Ongkir",
          style: TextStyle(
            fontWeight:
                FontWeight.bold, // Set FontWeight.bold to make the text bold
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 20.0),
              Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Row(children: [
                              DropdownButton<String>(
                                value: selectedCourier,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCourier = newValue!;
                                  });
                                },
                                items: <String>['jne', 'tiki', 'pos']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ])),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Column(
                            children: [
                              TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Berat (gr)',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    weightInput = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Text(
                        "Origin",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: Column(children: [
                            provinceData == null
                                ? UiLoading.loadingSmall()
                                : DropdownButton(
                                    isExpanded: true,
                                    value:
                                        selectedProvinceOrigin, // Use provinceData at the specified index
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    elevation: 4,
                                    style: TextStyle(color: Colors.black),
                                    hint: selectedProvinceOrigin == null
                                        ? Text('Pilih kota')
                                        : Text(selectedProvinceOrigin.province),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedProvinceOrigin = newValue;
                                        provinceIdOrigin =
                                            selectedProvinceOrigin.provinceId;
                                        cityDataOrigin =
                                            getCities(provinceIdOrigin);
                                        selectedCityOrigin = null;
                                        cityIdOrigin = null;
                                      });
                                    },
                                    items: provinceData!
                                        .map<DropdownMenuItem<Province>>(
                                            (Province value) {
                                      return DropdownMenuItem(
                                          value: value,
                                          child:
                                              Text(value.province.toString()));
                                    }).toList(),
                                  ),
                          ])),
                      Flexible(
                          flex: 1,
                          child: Column(children: [
                            Container(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: FutureBuilder<List<City>>(
                                  future: cityDataOrigin,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState !=
                                        ConnectionState.done) {
                                      return UiLoading.loadingSmall();
                                    }
                                    if (snapshot.hasData) {
                                      return DropdownButton(
                                          isExpanded: true,
                                          value: selectedCityOrigin,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 4,
                                          style: TextStyle(color: Colors.black),
                                          hint: selectedCityOrigin == null
                                              ? Text('Pilih kota')
                                              : Text(
                                                  selectedCityOrigin.cityName),
                                          items: snapshot.data!
                                              .map<DropdownMenuItem<City>>(
                                                  (City value) {
                                            return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.cityName.toString()));
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedCityOrigin = newValue;
                                              cityIdOrigin =
                                                  selectedCityOrigin.cityId;
                                            });
                                          });
                                    } else if (snapshot.hasError) {
                                      return Text("Tidak ada data");
                                    }
                                    return UiLoading.loadingSmall();
                                  }),
                            )
                          ]))
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Text(
                        "Destination",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: Column(children: [
                            provinceData == null
                                ? UiLoading.loadingSmall()
                                : DropdownButton(
                                    isExpanded: true,
                                    value:
                                        selectedProvinceDestination, // Use provinceData at the specified index
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    elevation: 4,
                                    style: TextStyle(color: Colors.black),
                                    hint: selectedProvinceDestination == null
                                        ? Text('Pilih kota')
                                        : Text(selectedProvinceDestination
                                            .province),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedCityDestination = null;
                                        cityIdDestination = null;
                                        cityDataDestination = null;
                                        selectedProvinceDestination = newValue;
                                        provinceIdDestination =
                                            selectedProvinceDestination
                                                .provinceId;
                                        cityDataDestination =
                                            getCities(provinceIdDestination);
                                        // Update the selected value in the list
                                      });
                                    },
                                    items: provinceData!
                                        .map<DropdownMenuItem<Province>>(
                                            (Province value) {
                                      return DropdownMenuItem(
                                          value: value,
                                          child:
                                              Text(value.province.toString()));
                                    }).toList(),
                                  ),
                          ])),
                      Flexible(
                          flex: 1,
                          child: Column(children: [
                            Container(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: FutureBuilder<List<City>>(
                                  future: cityDataDestination,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState !=
                                        ConnectionState.done) {
                                      return UiLoading.loadingSmall();
                                    }
                                    if (snapshot.hasData) {
                                      return DropdownButton(
                                          isExpanded: true,
                                          value: selectedCityDestination,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 4,
                                          style: TextStyle(color: Colors.black),
                                          hint: selectedCityDestination == null
                                              ? Text('Pilih kota')
                                              : Text(selectedCityDestination
                                                  .cityName),
                                          items: snapshot.data!
                                              .map<DropdownMenuItem<City>>(
                                                  (City value) {
                                            return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.cityName.toString()));
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedCityDestination =
                                                  newValue;
                                              cityIdDestination =
                                                  selectedCityDestination
                                                      .cityId;
                                            });
                                          });
                                    } else if (snapshot.hasError) {
                                      return Text("Tidak ada data");
                                    }
                                    return UiLoading.loadingSmall();
                                  }),
                            )
                          ]))
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            print(
                                "${cityIdOrigin}, ${cityIdDestination}, ${weightInput}, ${selectedCourier}");
                            if (cityIdOrigin != null &&
                                cityIdDestination != null &&
                                weightInput != '') {
                              getCosts(cityIdOrigin, cityIdDestination,
                                  weightInput, selectedCourier);
                              print(getCosts(cityIdOrigin, cityIdDestination,
                                  weightInput, selectedCourier));
                            } else {
                              isLoading = false;
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // Set the button color to blue
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Set border radius
                          ),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          'Hitung Estimasi Harga',
                          style: TextStyle(
                            fontWeight: FontWeight
                                .bold, // Set FontWeight.bold to make the text bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: costsData.isEmpty
                        ? const Align(
                            alignment: Alignment.center,
                            child: Text("Data tidak ditemukan"),
                          )
                        : ListView.builder(
                            itemCount: costsData.length,
                            itemBuilder: (context, index) {
                              print(costsData[index]);
                              return CardCost(costsData[index]);
                            })),
              ),
            ],
          ),
          isLoading == true ? UiLoading.loadingBlock() : Container()
        ],
      ),
    );
  }
}
