import 'package:flutter/material.dart';
// import 'package:flutter_linkify/flutter_linkify.dart';
// import 'package:url_launcher/url_launcher.dart';

class ItemWidget extends StatelessWidget {
  final String dataName;
  final List<dynamic> data;

  const ItemWidget({
    Key? key,
    required this.dataName,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      runSpacing: 20,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildContentList(
                            context, dataName, data[index]);
                      }),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildContentList(context, dataName, dynamic data) {
    if (dataName == "social_medias") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['platform'],
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .merge(const TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 5),
          // Text(
          //   data['url'],
          //   overflow: TextOverflow.ellipsis,
          //   softWrap: false,
          //   maxLines: 2,
          //   style: const TextStyle(color: Colors.grey),
          // ),
          // SelectableLinkify(
          //   onOpen: (link) async {
          //     // if (!await launch(link.url)) {
          //     //   throw 'Could not launch ${link.url}';
          //     // }
          //   },
          //   text: data['url'],
          //   maxLines: 1,
          //   style: const TextStyle(color: Colors.grey),
          // ),
          const SizedBox(height: 20),
        ],
      );
    } else if (dataName == "educations") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['institution'],
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .merge(const TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 5),
          Text(
            data['level'],
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .merge(const TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 5),
          Text(
            data['start_date'],
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            data['end_date'],
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
        ],
      );
    } else if (dataName == "societies") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['society_name'],
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .merge(const TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 5),
          Text(
            data['holding_position'],
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .merge(const TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 5),
          Text(
            data['start_date'],
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            data['end_date'],
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
        ],
      );
    } else if (dataName == "professional_certs") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['certificate_name'],
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .merge(const TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 5),
          Text(
            data['year_entitled'],
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
        ],
      );
    } else if (dataName == "work_experiences") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['company_name'],
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .merge(const TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 5),
          Text(
            data['entity'],
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            data['designation'],
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            data['business_category'],
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            data['start_date'],
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 5),
          data['current_role'] == 0
              ? Text(
                  data['end_date'],
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.grey),
                )
              : const Text(
                  "Currently still working",
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 2,
                  style: TextStyle(color: Colors.grey),
                ),
          const SizedBox(height: 20),
        ],
      );
    }
  }
}
