import 'package:flutter/material.dart';

class ChannelListAppBar extends StatelessWidget implements PreferredSizeWidget {
  ChannelListAppBar({
    Key key,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withAlpha(5),
                        borderRadius: BorderRadius.circular(32.0),
                        border:
                            Border.all(color: Colors.black.withOpacity(.2))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        style: TextStyle(
                          color: Colors.black.withOpacity(.5),
                          fontSize: 15,
                        ),
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixText: '   ',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              RawMaterialButton(
                onPressed: () {},
                constraints: BoxConstraints.tightFor(
                  height: 40,
                  width: 40,
                ),
                elevation: 1,
                fillColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Icon(
                  Icons.send,
                  color: Color(0xff006bff),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  final Size preferredSize;
}
