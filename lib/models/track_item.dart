import 'package:json_annotation/json_annotation.dart';

part 'track_item.g.dart';

@JsonSerializable()
class TrackItem {
  @JsonKey(name: 's')
  final int? s;

  @JsonKey(name: 'd')
  final int? d;

  @JsonKey(name: 'la')
  final String? la;

  @JsonKey(name: 'lo')
  final String? lo;

  @JsonKey(name: 'nt')
  final int? nt;

  @JsonKey(name: 'c')
  final int? c;

  @JsonKey(name: 't')
  final String? t;

  @JsonKey(name: 'ln')
  final String? ln;

  @JsonKey(name: 'ld')
  final String? ld;

  @JsonKey(name: 'f')
  final int? f;

  TrackItem({
    this.s,
    this.d,
    this.la,
    this.lo,
    this.nt,
    this.c,
    this.t,
    this.ln,
    this.ld,
    this.f,
  });

  factory TrackItem.fromJson(Map<String, dynamic> json) =>
      _$TrackItemFromJson(json);

  Map<String, dynamic> toJson() => _$TrackItemToJson(this);
}
