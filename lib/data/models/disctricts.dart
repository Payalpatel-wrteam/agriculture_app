class AllDistricts {
  List<AllDistricts>? districts;

  AllDistricts({this.districts});

  AllDistricts.fromJson(Map<String, dynamic> json) {
    if (json['districts'] != null) {
      districts = <AllDistricts>[];
      json['districts'].forEach((v) {
        districts!.add(AllDistricts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (districts != null) {
      data['districts'] = districts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Districts {
  String? subDistrict;
  List<String>? villages;

  Districts({this.subDistrict, this.villages});

  Districts.fromJson(Map<String, dynamic> json) {
    subDistrict = json['subDistrict'];
    villages = json['villages'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['subDistrict'] = subDistrict;
    data['villages'] = villages;
    return data;
  }

  }
