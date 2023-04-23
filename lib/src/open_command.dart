sealed class OpenCommand {}

class OpenWeChat extends OpenCommand {}

class OpenUrl extends OpenCommand {
  final String url;

  OpenUrl(this.url);
}

class OpenRankList extends OpenCommand {}
