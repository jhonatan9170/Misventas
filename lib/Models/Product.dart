class Product{
  int id;
  String url;
  String productName;
  int stock;
  int cantidad;
  double preciounit;
  double preciofinal;

  Product(this.id,this.url,this.productName,this.stock,this.cantidad,this.preciounit,this.preciofinal);
  double getDescuento(){
    return preciounit-preciofinal;
  }
}
