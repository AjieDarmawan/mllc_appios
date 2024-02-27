import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mlcc_app_ios/constant.dart';

class EventListPage extends StatefulWidget {
  final dynamic data;

  const EventListPage({Key? key, this.data}) : super(key: key);

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  String deviceID = '';
  int userId = 0;
  bool follow = false;

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return widget.data.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            itemCount: widget.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildEventsList(widget.data[index]);
            })
        : Center(
            child: SizedBox(
              height: 600.0,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("No records found!",
                        style: TextStyle(color: kThirdColor.withOpacity(0.7))),
                  ]),
            ),
          );
  }

  Widget _buildEventsList(dynamic data) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/event_details_view_page',
            arguments: {'data': data});
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: kThirdColor.withOpacity(0.3),
              blurRadius: 10,
            ),
          ],
          border: Border.all(color: kPrimaryColor.withOpacity(0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                SizedBox(
                  width: 75,
                  height: 75,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child:
                        (data['thumbnail'] != null && data['thumbnail'] != "")
                            ? CachedNetworkImage(
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.values[0],
                                imageUrl: data['thumbnail'],
                                placeholder: (context, url) => Image.asset(
                                  'assets/loading.gif',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 140,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error_outline),
                              )
                            : Image.asset(
                                'assets/mlcc_logo.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 140,
                              ),
                  ),
                ),
                Positioned(
                  bottom: 3,
                  right: 3,
                  width: 12,
                  height: 12,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(width: 15),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data['title'],
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: Theme.of(context).textTheme.bodyText1!.merge(
                              const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: kPrimaryColor)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          data['caption'],
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: Theme.of(context).textTheme.bodyText1!.merge(
                              TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: kThirdColor.withOpacity(0.8))),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      data['payment'] == 1
                          ? Expanded(
                              child: Text(
                                data['price'],
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .merge(TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: kThirdColor.withOpacity(0.8))),
                              ),
                            )
                          : Expanded(
                              child: Text(
                                "Free",
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .merge(TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: kThirdColor.withOpacity(0.8))),
                              ),
                            ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
