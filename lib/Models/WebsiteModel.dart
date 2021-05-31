class Website {
  int tf;
  int titleFrequency;
  int plainTextFrequency;
  int headingsFrequency;
  String url;

  Website(
      {this.headingsFrequency,
      this.plainTextFrequency,
      this.tf,
      this.titleFrequency,
      this.url});

  factory Website.fromJson(Map<String, dynamic> json) {
    return Website(
      headingsFrequency: json["headingsFrequency"],
      plainTextFrequency: json["plainTextFrequency"],
      tf: json["TF"],
      titleFrequency: json["titleFrequency"],
      url: json["url"],
    );
  }
}
