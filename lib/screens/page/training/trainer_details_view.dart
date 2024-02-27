import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/widget/til_widget.dart';
import 'package:mlcc_app_ios/widget/title_bar_widget.dart';

class TrainerDetailsViewPage extends StatefulWidget {
  const TrainerDetailsViewPage({Key? key}) : super(key: key);

  @override
  _TrainerDetailsViewPageState createState() => _TrainerDetailsViewPageState();
}

String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}

class _TrainerDetailsViewPageState extends State<TrainerDetailsViewPage> {
  @override
  Widget build(BuildContext context) {
    final dynamic args = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Trainer Details",
          style: TextStyle(
            color: kSecondaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: CustomScrollView(
        primary: true,
        shrinkWrap: true,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            expandedHeight: 310,
            elevation: 0,
            floating: true,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            centerTitle: true,
            pinned: true,
            automaticallyImplyLeading: false,
            bottom: trainingTitleBarWidget(args['data']['name']),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  (args['data']['thumbnail'] != null &&
                          args['data']['thumbnail'] != "")
                      ? CachedNetworkImage(
                          height: 350,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          imageUrl: args['data']['thumbnail'],
                          placeholder: (context, url) => Image.asset(
                            'assets/loading.gif',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 350,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error_outline),
                        )
                      : Image.asset(
                          'assets/mlcc_logo.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 350,
                        ),
                ],
              ),
            ).marginOnly(bottom: 70),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                args['data']['category'] != null
                    ? TilWidget(
                        actions: const [],
                        title: const Text("Category",
                            style:
                                TextStyle(fontSize: 16, color: kPrimaryColor)),
                        content: Text(
                          args['data']['category'],
                          textAlign: TextAlign.left,
                          // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                        ))
                    : Container(),
                args['data']['description'] != null
                    //  ? Text("tes")
                    ? TilWidget(
                        actions: const [],
                        title: const Text("Description",
                            style:
                                TextStyle(fontSize: 16, color: kPrimaryColor)),
                        // content: Text(
                        //   _parseHtmlString(args['data']['description']),
                        //   textAlign: TextAlign.left,
                        //   // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                        // )
                        content: Html(
                          data: args['data']['description'],
                          onLinkTap: (url, _, __, ___) {
                            launch(url!);
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TitleBarWidget trainingTitleBarWidget(trainerName) {
    return TitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  trainerName,
                  style: Theme.of(context).textTheme.headline5!.merge(
                      const TextStyle(height: 1.1, color: kPrimaryColor)),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
