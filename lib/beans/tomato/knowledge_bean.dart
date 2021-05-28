import 'package:json_annotation/json_annotation.dart';

part 'knowledge_bean.g.dart';

@JsonSerializable()
class KnowledgeBean {
  final String url;
  final String title;
  final String type;
  final String module;
  KnowledgeBean(this.url, this.title, this.type, this.module);
  factory KnowledgeBean.fromJson(Map<String, dynamic> json) => _$KnowledgeBeanFromJson(json);
  Map<String, dynamic> toJson() => _$KnowledgeBeanToJson(this);
}
