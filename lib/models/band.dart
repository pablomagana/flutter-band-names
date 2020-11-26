class Band {
  Band({
    this.id,
    this.name,
    this.votes,
  });

  String id;
  String name;
  int votes;

  factory Band.fromMap(Map<String, dynamic> json) => Band(
        id: json.containsKey('id') ? json["id"] : 'no-id',
        name: json.containsKey('name') ? json["name"] : 'no-name',
        votes: json.containsKey('votes') ? json["votes"] : 'no-votes',
      );
}
