
class MyData {
   String? fullName;
   String? mobileNo;
   List<String>? selectedOccupation;
   String? workExp;
   String? place;
   String? city;
   String? state;
   String? pin;
   String? url;
   String? uid;


  MyData({
    required this.fullName,
    required this.mobileNo,
    required this.selectedOccupation,
    required this.workExp,
    required this.place,
    required this.city,
    required this.state,
    required this.pin,
    required this.url,
    required this.uid
  });

   Map<String, dynamic> toMap() {
     return {
       'fullName': fullName,
       'mobileNo': mobileNo,
       'selectedOccupation': selectedOccupation,
       'workExp': workExp,
       'place': place,
       'city': city,
       'state': state,
       'pin': pin,
       'url': url,
       'uid': uid,
     };
   }
}