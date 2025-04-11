import 'package:untitled6/Graphe/Ind_bar.dart';

class BarData {
final double janamount;
final double fivamount;
final double marnamount;
final double apramount;
final double maiamount;
final double junamount;
final double julamount;
BarData( {


required this.janamount, required this.fivamount, required this.marnamount,required this.apramount,required this.maiamount,required this.junamount,required this.julamount,

});
List<Ind_bar> barlist=[];
void intlist (){
barlist=[
Ind_bar(users: janamount, month: "janvier"),
Ind_bar(users: fivamount, month: "fivrier"),
Ind_bar(users: marnamount, month: "march"),
Ind_bar(users: apramount, month: "april"),
Ind_bar(users: maiamount, month: "mai"),
Ind_bar(users: junamount, month: "june"),
Ind_bar(users: julamount, month: "july")

];




}


}