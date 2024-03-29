import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Provider/CategoryProvider.dart';
import 'package:eshop_multivendor/Provider/HomeProvider.dart';
import 'package:eshop_multivendor/Screen/SellerList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../Helper/Session.dart';
import '../Model/Section_Model.dart';
import 'HomePage.dart';
import 'ProductList.dart';

class AllCategory extends StatefulWidget {
  @override
  State<AllCategory> createState() => _AllCategoryState();
}

class _AllCategoryState extends State<AllCategory> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(milliseconds: 300),(){
    //   return getCat();
    // });
  }

  Future<void> getCat() async {
    await Future.delayed(Duration.zero);
    Map parameter = {
      CAT_FILTER: "false",
    };
    apiBaseHelper.postAPICall(getCatApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];

        catList =
            (data as List).map((data) => new Product.fromCat(data)).toList();

        // if (getdata.containsKey("popular_categories")) {
        //   var data = getdata["popular_categories"];
        //   popularList =
        //       (data as List).map((data) => new Product.fromCat(data)).toList();
        //
        //   if (popularList.length > 0) {
        //     Product pop =
        //         new Product.popular("Popular", imagePath + "popular.svg");
        //     catList.insert(0, pop);
        //     context.read<CategoryProvider>().setSubList(popularList);
        //   }
        // }
      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setCatLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setCatLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, _) {
          if (homeProvider.catLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Row(
            children: [
             /* Expanded(
                flex: 1,
                child: Container(
                  color: Theme.of(context).colorScheme.gray,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsetsDirectional.only(top: 10.0),
                    itemCount: catList.length,
                    itemBuilder: (context, index) {
                      return catItem(index, context);
                    },
                  ),
                ),
              ),*/
              Expanded(
                flex: 3,
                child: catList.length > 0
                    ? Column(
                        children: [
                          Selector<CategoryProvider, int>(
                            builder: (context, data, child) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                  /*  Row(
                                      children: [
                                        Text(catList[data].name! + " "),
                                        Expanded(
                                          child: Divider(
                                            thickness: 2,
                                          ),
                                        ),
                                      ],
                                    ),*/
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       vertical: 8.0),
                                    //   child: Text(
                                    //     getTranslated(context, 'All')! +
                                    //         " " +
                                    //         catList[data].name! +
                                    //         " ",
                                    //     style: TextStyle(
                                    //       color: Theme.of(context)
                                    //           .colorScheme
                                    //           .fontColor,
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: 16,
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              );
                            },
                            selector: (_, cat) => cat.curCat,
                          ),
                          Expanded(
                            child: Selector<CategoryProvider, List<Product>>(
                              builder: (context, data, child) {
                                return catList.length > 0
                                    ? GridView.count(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        crossAxisCount: 3,
                                        shrinkWrap: true,
                                        childAspectRatio: .75,
                                        children: List.generate(
                                          catList.length,
                                          (index) {
                                            return subCatItem(
                                                catList, index, context);
                                          },
                                        ))
                                    : Center(
                                        child: Text(
                                            getTranslated(context, 'noItem')!));
                              },
                              selector: (_, categoryProvider) =>
                                  categoryProvider.subList,
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget catItem(int index, BuildContext context1) {
    return Selector<CategoryProvider, int>(
      builder: (context, data, child) {
        if (index == 0 && (popularList.length > 0)) {
          return GestureDetector(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: data == index
                      ? Theme.of(context).colorScheme.white
                      : Colors.transparent,
                  border: data == index
                      ? Border(
                          left: BorderSide(width: 5.0, color: colors.primary),
                        )
                      : null
                  // borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: SvgPicture.asset(
                        data == index
                            ? imagePath + "popular_sel.svg"
                            : imagePath + "popular.svg",
                        color: colors.primary,
                      ),
                    ),
                  ),
                  Text(
                    catList[index].name! + "\n",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context1).textTheme.caption!.copyWith(
                        color: data == index
                            ? colors.primary
                            : Theme.of(context).colorScheme.fontColor),
                  )
                ],
              ),
            ),
            onTap: () {
              context1.read<CategoryProvider>().setCurSelected(index);
              context1.read<CategoryProvider>().setSubList(popularList);
            },
          );
        } else {
          return GestureDetector(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: data == index
                      ? Theme.of(context).colorScheme.white
                      : Colors.transparent,
                  border: data == index
                      ? Border(
                          left: BorderSide(width: 5.0, color: colors.primary),
                        )
                      : null),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: FadeInImage(
                            image: CachedNetworkImageProvider(
                                catList[index].image!),
                            fadeInDuration: Duration(milliseconds: 150),
                            fit: BoxFit.fill,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                erroWidget(50),
                            placeholder: placeHolder(50),
                          )),
                    ),
                  ),
                  Text(
                    catList[index].name! + "\n",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context1).textTheme.caption!.copyWith(
                        color: data == index
                            ? colors.primary
                            : Theme.of(context).colorScheme.fontColor),
                  )
                ],
              ),
            ),
            onTap: () {
              context1.read<CategoryProvider>().setCurSelected(index);
              if (catList[index].subList == null ||
                  catList[index].subList!.length == 0) {
                context1.read<CategoryProvider>().setSubList([]);
                Navigator.push(
                    context1,
                    MaterialPageRoute(
                      builder: (context) => ProductList(
                        name: catList[index].name,
                        id: catList[index].id,
                        tag: false,
                        fromSeller: false,
                      ),
                    ));
              } else {
                context1
                    .read<CategoryProvider>()
                    .setSubList(catList[index].subList);
              }
            },
          );
        }
      },
      selector: (_, cat) => cat.curCat,
    );
  }

  subCatItem(List<Product> subList, int index, BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: FadeInImage(
                  image: CachedNetworkImageProvider(subList[index].image!),
                  fadeInDuration: Duration(milliseconds: 150),
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height*0.12,
                  width: MediaQuery.of(context).size.height*0.12,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      erroWidget(50),
                  placeholder: placeHolder(50),
                )),
          ),
          Text(
            subList[index].name! + "\n",
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(color: Theme.of(context).colorScheme.fontColor),
          )
        ],
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>SellerList(
              catId: catList[index].id,
              catName: catList[index].name,
              subId: catList[index].subList,
              getByLocation: false,
            )));
        // if (context.read<CategoryProvider>().curCat == 0 &&
        //     popularList.length > 0) {
        //   if (popularList[index].subList == null ||
        //       popularList[index].subList!.length == 0) {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => ProductList(
        //             name: popularList[index].name,
        //             id: popularList[index].id,
        //             tag: false,
        //             fromSeller: false,
        //           ),
        //         ));
        //   } else {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => SubCategory(
        //             title: popularList[index].name ?? "",
        //           ),
        //         ));
        //   }
        // } else if (subList[index].subList == null ||
        //     subList[index].subList!.length == 0) {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => ProductList(
        //           name: subList[index].name,
        //           id: subList[index].id,
        //           tag: false,
        //           fromSeller: false,
        //         ),
        //       ));
        // } else {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => SubCategory(
        //           title: subList[index].name ?? "",
        //         ),
        //       ));
        // }
      },
    );
  }
}
