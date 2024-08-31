import 'package:flutter/material.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';

class ScreenSelecte extends StatefulWidget {
  ScreenSelecte({super.key});

  @override
  State<ScreenSelecte> createState() => _ScreenSelecteState();
}

class _ScreenSelecteState extends State<ScreenSelecte> {
  List<String> names = ["Mammooty", "Mohanlal", "Fahad Fasil", "Tovino"];
  ValueNotifier<bool> selectAll = ValueNotifier<bool>(false);
  late List<ValueNotifier<bool>> isSelected;

  @override
  void initState() {
    super.initState();
    isSelected =
        List.generate(names.length, (index) => ValueNotifier<bool>(false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color.fromARGB(255, 179, 17, 155),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: white),
        title: Text(
          "Song Selected",
          style: TextStyle(color: white),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          //gradient: AppColors.background,
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: Column(
          children: [
            // Select All
            ValueListenableBuilder(
              valueListenable: selectAll,
              builder: (BuildContext context, bool value, Widget? child) {
                return ListTile(
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Handle delete action
                        },
                        icon: Icon(Icons.delete, color: white),
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle add playlist action
                        },
                        icon: Icon(Icons.playlist_add, color: white),
                      ),
                    ],
                  ),
                  title: Text(
                    "Select All",
                    style: TextStyle(
                      color: white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    selectAll.value = !value;
                    for (var i in isSelected) {
                      i.value = selectAll.value;
                    }
                  },
                  leading: Icon(
                    value ? Icons.check_box : Icons.check_box_outline_blank,
                    color: white,
                  ),
                );
              },
            ),
            // Songs item
            Expanded(
              child: ListView.builder(
                //physics: BouncingScrollPhysics(),
                itemCount: names.length,
                itemBuilder: (context, index) {
                  return ValueListenableBuilder(
                    valueListenable: isSelected[index],
                    builder: (BuildContext context, bool value, Widget? child) {
                      return ListTile(
                        leading: Icon(
                          value
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: white,
                        ),
                        title: musicCard(
                          image:
                              "https://i.ytimg.com/vi/RgOEKdA2mlw/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLAmheQ8_nbR7Trrpapl6B7Ko0xKkw",
                          musicName: "Water Packet - Video song",
                          artistName: "Sun Tv",
                          operation: () {},
                          context: context,
                        ),
                        onTap: () {
                          isSelected[index].value = !value;
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
