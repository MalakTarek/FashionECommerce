import 'package:flutter/material.dart';
import '../Products/vendorProducts.dart';  // Import the VendorProductPage

class VendorProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: 360,
            height: 640,
            decoration: BoxDecoration(color: Colors.white),
            child: Stack(
              children: [
                Positioned(
                  left: -11,
                  top: -3,
                  child: Container(
                    width: 429,
                    height: 645,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 116,
                          top: 673,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Explore More',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0.09,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 166,
                          top: 32,
                          child: SizedBox(
                            width: 120.49,
                            height: 13.37,
                            child: Text(
                              'Profile',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 0.06,
                                letterSpacing: 0.56,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 19,
                          top: 27,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                          ),
                        ),
                        Positioned(
                          left: 13,
                          top: 597,
                          child: Container(
                            width: 360,
                            height: 48,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 360,
                                  height: 48,
                                  decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage("https://via.placeholder.com/16x16"),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 14,
                                        height: 14,
                                        decoration: ShapeDecoration(
                                          color: Color(0xFF797979),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 66,
                          top: 327,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VendorProductPage(),
                                ),
                              );
                            },
                            child: Text(
                              'View My Products',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 352,
                          top: 336,
                          child: Opacity(
                            opacity: 0.65,
                            child: Container(
                              width: 14,
                              height: 14,
                            ),
                          ),
                        ),
                        Positioned(
                          left: -1,
                          top: 281,
                          child: Container(
                            width: 390,
                            height: 29,
                            decoration: BoxDecoration(color: Color(0xFFF6F6F6)),
                          ),
                        ),
                        Positioned(
                          left: 25,
                          top: 286,
                          child: Text(
                            'Content',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 36,
                          top: 231,
                          child: SizedBox(
                            width: 66,
                            height: 17,
                            child: Text(
                              'Name:',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 133,
                          top: 231,
                          child: Text(
                            'Mohammed',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 247,
                          top: 225,
                          child: Container(
                            width: 105,
                            height: 29,
                            decoration: ShapeDecoration(
                              color: Color(0xFF171E1D),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 259,
                          top: 230,
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 25,
                          top: 330,
                          child: Container(width: 39, height: 26),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 360,
                    height: 24,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
                Positioned(
                  left: 278,
                  top: 6,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 18,
                        height: 12,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage("https://via.placeholder.com/18x12"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 16,
                        height: 12,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage("https://via.placeholder.com/16x12"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 24,
                        height: 12,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Opacity(
                                opacity: 0.40,
                                child: Container(
                                  width: 24,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage("https://via.placeholder.com/24x12"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 1.97,
                              top: 2.12,
                              child: Container(
                                width: 17.76,
                                height: 7.76,
                                decoration: ShapeDecoration(
                                  color: Color(0xFF170E2B),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1.33),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 4,
                  child: Text(
                    '12:30',
                    style: TextStyle(
                      color: Color(0xFF170E2B),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: 0.01,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
