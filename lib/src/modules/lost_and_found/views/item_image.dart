import 'package:flutter/material.dart';

class ItemImage extends StatelessWidget {
  const ItemImage(
      {Key? key,
      this.img,
      this.size = 60.0,
      this.radius = 8.0,
      this.isNetwork = false})
      : super(key: key);

  final String? img;

  final double size;

  final double radius;

  final bool isNetwork;

  final String dummyImg = 'assets/images/profile.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.white,
        image: img == null
            ? DecorationImage(
                image: AssetImage(dummyImg),
                fit: BoxFit.contain,
                scale: 0.3,
              )
            : isNetwork
                ? img!.isEmpty
                    ? DecorationImage(
                        image: AssetImage(dummyImg),
                        fit: BoxFit.contain,
                        scale: 0.3,
                      )
                    : DecorationImage(
                        image: NetworkImage(img!),
                        fit: BoxFit.cover,
                      )
                : DecorationImage(
                    image: AssetImage(img!),
                    fit: BoxFit.contain,
                    scale: 0.3,
                  ),
      ),
    );
  }
}
// const AssetImage('assets/images/lost_n_found.png')