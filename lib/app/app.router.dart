// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:epub_reader/ui/home/home_view.dart';
import 'package:epub_reader/ui/pdf/pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../core/model/book_details_model.dart';

class Routes {
  static const String homeView = '/';
  static const String pdfView = '/pdf-view';
  static const all = <String>{
    homeView,
    pdfView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.pdfView, page: PdfView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeView(),
        settings: data,
      );
    },
    PdfView: (data) {
      var args = data.getArgs<PdfViewArguments>(
        orElse: () => PdfViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => PdfView(
          key: args.key,
          bookDetails: args.bookDetails,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// PdfView arguments holder class
class PdfViewArguments {
  final Key key;
  final BookDetails bookDetails;
  PdfViewArguments({this.key,this.bookDetails});
}
