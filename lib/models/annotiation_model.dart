import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

part 'annotiation_model.g.dart';

@HiveType(typeId: 1)
class AnnotationModel {
  @HiveField(0)
  Annotation? annotation;

  AnnotationModel({this.annotation});
}
