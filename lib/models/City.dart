const String TableCity = 'cities';


class CityFields{

  

  static const String Id_city = '_id';
  static const String Libelle = 'Libelle';
}


class City {
  final int? Id_city;
  final String? Libelle;

  const City({
    this.Id_city,
    this.Libelle,
  });
  

  City copy({
    int? Id_city,
    String? Libelle,
  }) => City(
    Id_city: Id_city ?? this.Id_city,
    Libelle: Libelle ?? this.Libelle
  );
  
  

 static City fromJson(Map<String,Object?> json) => City(
    Id_city :json[CityFields.Id_city] as int?,
    Libelle : json[CityFields.Libelle] as String?,
  );


  Map<String,Object?> toJson() => {
    CityFields.Id_city : Id_city,
    CityFields.Libelle : Libelle,
  };
  

}