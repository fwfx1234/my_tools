// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KnowledgeBean _$KnowledgeBeanFromJson(Map<String, dynamic> json) {
  return KnowledgeBean(
    json['url'] as String,
    json['title'] as String,
    json['type'] as String,
    json['module'] as String,
  );
}

Map<String, dynamic> _$KnowledgeBeanToJson(KnowledgeBean instance) =>
    <String, dynamic>{
      'url': instance.url,
      'title': instance.title,
      'type': instance.type,
      'module': instance.module,
    };
