class Topic {
  final int id;
  final String summary;
  final String memo;
  final String tags_string;
  final int created_at;
  final int updated_at;

  Topic({this.id, this.summary, this.memo, this.tags_string, this.created_at, this.updated_at});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'summary': summary,
      'memo': memo,
      'tags_string': tags_string,
      'created_at': created_at,
      'updated_at': updated_at,
    }
  }
}
