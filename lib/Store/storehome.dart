import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
          decoration: new BoxDecoration(
            color: Color(0xFFFDBE3B),
          ),
        ),
        title: Text(
          "DROP IT",
          style: TextStyle(fontSize: 30.0, color: Color(0xFF5C4057), fontFamily: "Poppins" ),

        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart,color: Colors.pink,), 
                onPressed:()
                {
                  Route route = MaterialPageRoute(builder: (c) => CartPage());
                  Navigator.pushReplacement(context, route);
                },
             ),
             Positioned(
               child: Stack(
                 children: [
                   Icon(
                     Icons.brightness_1,
                     size: 20.0,
                      color: Colors.green,
                    ),
                    Positioned(
                      top: 3.0,
                      bottom: 4.0,
                      left: 4.0 ,
                      child: Consumer<CartItemCounter>(
                        builder: (context,counter, _)
                        {
                           return Text(
                             (DropItApp.sharedPreferences.getStringList(DropItApp.userCartList).length-1).toString(),
                              style: TextStyle(color: Colors.white, fontSize: 12.0,fontWeight: FontWeight.w500),
                           );
                        },
                      ),
                    ),
                  ],
               ),
              ),
            ],
          ),
        ],
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("items").limit(15).orderBy("publishedDate",descending: true).snapshots(),
              builder: (context, dataSnapshot)
              {
                return !dataSnapshot.hasData
                   ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                   : SliverStaggeredGrid.countBuilder(
                     crossAxisCount: 1,
                     staggeredTileBuilder: (c)=>StaggeredTile.fit(1),
                     itemBuilder: (context,index)
                     {
                       ItemModel model= ItemModel.fromJson(dataSnapshot.data.docs[index].data());
                       return sourceInfo(model, context);
                     },
                 itemCount: dataSnapshot.data.docs.length,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: ()
    {
      Route route = MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
      Navigator.pushReplacement(context, route);
    },
    splashColor: Color(0xFF5C4057),
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 250.0,
        width: width,
        child: Row(
          children: [
            Image.network(model.thumbnailUrl,width: 140.0,height:140.0,),
            SizedBox(width: 4.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.0,),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(model.title,style: TextStyle(color: Color(0xFF5C4057), fontSize: 14.0),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height:5.0,),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(model.shortInfo,style: TextStyle(color:Color(0xFF5C4057), fontSize: 12.0),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height:20.0,),
                  Row(
                    children: [
                     Container(
                       decoration: BoxDecoration(
                         shape: BoxShape.rectangle,
                         color:Color(0xFFFDBE3B),
                        ),
                        alignment: Alignment.topLeft,
                        width: 40.0,
                        height: 43.0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "50%", style: TextStyle(fontSize: 15.0,color: Color(0xFF5C4057),fontWeight: FontWeight.normal),
                              ),
                              Text(
                                "OFF", style: TextStyle(fontSize: 12.0,color: Color(0xFF5C4057),fontWeight: FontWeight.normal),
                              ),

                            ],
                          ) ,
                        ),
                     ),
                     SizedBox(width:10.0,),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Padding(
                           padding: EdgeInsets.only(top: 0.0),
                           child: Row(
                             children: [
                               Text(
                                 r"Original Price: ₹ ",
                                 style: TextStyle(
                                   fontSize: 14.0,
                                   color: Color(0xFF5C4057),
                                   decoration: TextDecoration.lineThrough
                                  ),
                               ),
                               Text(
                                 (model.price + model.price).toString(),
                                 style: TextStyle(
                                   fontSize: 15.0,
                                   color:Color(0xFF5C4057),
                                   decoration: TextDecoration.lineThrough,
                                 ),
                               ),
                             ],
                           ),
                         ),

                         Padding(
                           padding: EdgeInsets.only(top: 5.0),
                           child: Row(
                             children: [
                               Text(
                                 r"New Price: ",
                                 style: TextStyle(
                                   fontSize: 14.0,
                                   color: Color(0xFF5C4057),
                                 ),
                               ),
                               Text(
                                 "₹ ",
                                 style: TextStyle(color:Color(0xFFFDBE3B),fontSize: 16.0),
                                ),
                               Text(
                                 (model.price).toString(),
                                 style: TextStyle(
                                   fontSize: 15.0,
                                   color: Color(0xFF5C4057),
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ],
                      ),
                    ],
                  ),
                  Flexible(
                    child: Container(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: removeCartFunction == null
                    ?IconButton(
                      icon: Icon(Icons.add_shopping_cart,color:Color(0xFFFDBE3B),),
                      onPressed: ()
                      {
                        checkItemInCart(model.shortInfo, context);
                      },
                    )
                    :IconButton(
                      icon: Icon(Icons.delete,color:Color(0xFFFDBE3B),),
                      onPressed: ()
                      {
                        removeCartFunction();
                        Route route = MaterialPageRoute(builder: (c) => StoreHome());
                        Navigator.pushReplacement(context, route);
                      },
                    ),
                  ),
                  Divider(
                    height: 5.0,
                    color: Color(0xFF5C4057),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}



Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150.0,
    width: width* .34,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(offset: Offset(0,5), blurRadius: 10.0, color: Colors.grey[200]),
      ]
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Image.network(
        imgPath,
        height: 150.0,
        width: width* .34,
        fit: BoxFit.fill,
      ),
    ),
  );
}



void checkItemInCart(String shortInfoAsID, BuildContext context)
{
  DropItApp.sharedPreferences.getStringList(DropItApp.userCartList).contains(shortInfoAsID)
  ? Fluttertoast.showToast(msg: "Item is already in Cart")
  : addItemToCart(shortInfoAsID, context);
}

addItemToCart(String shortInfoAsID, BuildContext context)
{
  List tempCartList = DropItApp.sharedPreferences.getStringList(DropItApp.userCartList);
  tempCartList.add(shortInfoAsID);

  DropItApp.firestore.collection(DropItApp.collectionUser)
    .doc(DropItApp.sharedPreferences.getString(DropItApp.userUID))
    .update({
      DropItApp.userCartList: tempCartList,
    }).then((v){
      Fluttertoast.showToast(msg: "Item added to cart.");
      DropItApp.sharedPreferences.setStringList(DropItApp.userCartList, tempCartList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
}