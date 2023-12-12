import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voice_travel/core/constance/app_color.dart';

class ExtractedEntityCell extends StatefulWidget {
  const ExtractedEntityCell({super.key, required this.entity});

  final EntityAnnotation entity;
  @override
  State<ExtractedEntityCell> createState() => _ExtractedEntityCellState();
}

class _ExtractedEntityCellState extends State<ExtractedEntityCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: ExpansionTile(
          textColor: AppColor.backgroundIcon2,
          collapsedTextColor: Colors.black87,
          title: Text(widget.entity.text, style: const TextStyle(fontSize: 18),),
          children: widget.entity.entities
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _getAction(e, widget.entity.text),
                ),
              )
              .toList()),
    );
  }

  Widget _getAction(Entity entity, String text) {
    final type = entity.type;
    if (type == EntityType.address) {
      return GestureDetector(
        onTap: () async {
          EasyLoading.show();
          String query = Uri.encodeComponent(text);
          Uri googleUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
          try {
            await launchUrl(googleUrl);
          } catch (e) {}
          EasyLoading.dismiss();
        },
        child: Row(
          children: [
            const Image(image: AssetImage('assets/images/google-maps.png'), height: 30,width: 30,),
            const SizedBox(width: 10,),
            Text('Search $text on Google Map', style: const TextStyle(fontSize: 18)),
          ],
        ),
      );
    }
    if (type == EntityType.dateTime) {
      final timeStamp = (entity as DateTimeEntity).timestamp;
      return GestureDetector(
        onTap: () async {
          EasyLoading.show();
          Uri dateTimeUrl = Uri.parse("content://com.android.calendar/time/?time=$timeStamp");
          try {
            await launchUrl(dateTimeUrl);
          } catch (e) {}
          EasyLoading.dismiss();
        },
        child: const Row(
          children: [
            Image(image: AssetImage('assets/images/calendar.png'), height: 30,width: 30,),
            SizedBox(width: 10,),
            Text('Open calendar', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }
    if (type == EntityType.email) {
      final mailAddress = text;
      return GestureDetector(
        onTap: () async {
          EasyLoading.show();
          Uri emailLaunchUri = Uri(
              scheme: 'mailto',
              path: mailAddress,
          );
          try {
            await launchUrl(emailLaunchUri);
          } catch (e) {}
          EasyLoading.dismiss();
        },
        child: Row(
          children: [
            const Image(image: AssetImage('assets/images/gmail.png'), height: 30,width: 30,),
            const SizedBox(width: 10,),
            Text('Send mail to $mailAddress', style: const TextStyle(fontSize: 18)),
          ],
        ),
      );
    }
    if (type == EntityType.phone) {
      return GestureDetector(
        onTap: () async {
          EasyLoading.show();
          Uri phoneLaunchUri =  Uri(
              scheme: 'tel',
              path: text,
          );
          try {
            await launchUrl(phoneLaunchUri);
          } catch (e) {}
          EasyLoading.dismiss();
        },
        child: Row(
          children: [
            const Image(image: AssetImage('assets/images/telephone.png'), height: 30,width: 30,),
            const SizedBox(width: 10,),
            Text('Make a call with $text', style: const TextStyle(fontSize: 18)),
          ],
        ),
      );
    }
    if (type == EntityType.url) {
      return GestureDetector(
        onTap: () async {
          EasyLoading.show();
          Uri url =  Uri.parse(text);
          if (!url.toString().startsWith("http://") && !url.toString().startsWith("https://")) {
            url = Uri.parse("http://$text");
          }
          try {
            await launchUrl(url);
          } catch (e) {
            print("error $e");
          }
          EasyLoading.dismiss();
        },
        child: Row(
          children: [
            const Image(image: AssetImage('assets/images/chrome.png'), height: 30,width: 30,),
            const SizedBox(width: 10,),
            Text('Open $text', style: const TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () async {
        EasyLoading.show();
        String query = Uri.encodeComponent(text);
        Uri url =  Uri.parse("https://www.google.com/search?q=$query");
        try {
          await launchUrl(url);
        } catch (e) {}
        EasyLoading.dismiss();
      },
      child: Row(
        children: [
          const Image(image: AssetImage('assets/images/chrome.png'), height: 30,width: 30,),
          const SizedBox(width: 10,),
          Text('Search $text', style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
