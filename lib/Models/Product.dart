class Product{
  int id;
  String url;
  String productName;
  int stock;
  int cantidad;
  double preciounit;
  double preciofinal;
  double precioCosto;
  String estado;

  Product(this.id,this.url,this.productName,this.stock,this.cantidad,this.preciounit,this.preciofinal,this.precioCosto,this.estado);
  double getDescuento(){
    return preciounit-preciofinal;
  }
}
