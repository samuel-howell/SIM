class StoreDataTotal {
//our flspot data has to be in the form <double, double>

  DateTime date;
  double profit;

  StoreDataTotal(this.date, this.profit);

  @override
  String toString() {
    return '{ ${this.date}, ${this.profit} }';
  }
}
