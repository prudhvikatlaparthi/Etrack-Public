// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackItem _$TrackItemFromJson(Map<String, dynamic> json) => TrackItem(
      s: (json['s'] as num?)?.toInt(),
      d: (json['d'] as num?)?.toInt(),
      la: json['la'] as String?,
      lo: json['lo'] as String?,
      nt: (json['nt'] as num?)?.toInt(),
      c: (json['c'] as num?)?.toInt(),
      t: json['t'] as String?,
      ln: json['ln'] as String?,
      ld: json['ld'] as String?,
      f: (json['f'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TrackItemToJson(TrackItem instance) => <String, dynamic>{
      's': instance.s,
      'd': instance.d,
      'la': instance.la,
      'lo': instance.lo,
      'nt': instance.nt,
      'c': instance.c,
      't': instance.t,
      'ln': instance.ln,
      'ld': instance.ld,
      'f': instance.f,
    };
