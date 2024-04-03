import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_gallery/core/providers/user_provider.dart';
import 'package:my_gallery/core/utils/core_utils.dart';
import 'package:my_gallery/src/auth/data/models/user_modal.dart';
import 'package:my_gallery/src/gallery/presenation/bloc/gallery_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GalleryScreen extends StatefulWidget {
  static const routeName = '/gallery';
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  void didChangeDependencies() {
    final user = Provider.of<UserProvider>(context).user!;
    BlocProvider.of<GalleryBloc>(context)
        .add(GetGalleryEvent(token: user.token));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user!;

    return SafeArea(
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Image.asset(
              "assets/images/gallery_bg.png",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Welcome \n${user.username}',
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                actionRow(userProvider, context, user),
                SizedBox(
                  height: 5.h,
                ),
                BlocConsumer<GalleryBloc, GalleryState>(
                  builder: (builder, state) {
                    if (state is GalleryLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is GalleryLoaded) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 3 / 3,
                        ),
                        itemBuilder: (context, index) {
                          return imgGridTile(state, index);
                        },
                        itemCount: state.galleryModal.imageUrl.length,
                      );
                    } else {
                      return Container();
                    }
                  },
                  listener: (context, state) {
                    if (state is GalleryError) {
                      CoreUtils.showSnackBar(context, state.message);
                    }

                    if (state is ImgUploaded) {
                      CoreUtils.showSnackBar(context, 'Image Uploaded');
                      BlocProvider.of<GalleryBloc>(context)
                          .add(GetGalleryEvent(token: user.token));
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget actionRow(
      UserProvider userProvider, BuildContext context, UserModel user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        getAppButton(
          () {
            userProvider.logout();
            Navigator.pop(context);
          },
          'logout',
          Icons.arrow_back,
          Colors.red,
        ),
        getAppButton(
          () {
            showDialog(
                context: context,
                builder: (builder) {
                  return AlertDialog(
                    backgroundColor: Colors.white.withOpacity(0.5),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        getAppButton(() {
                          pickImage(ImageSource.camera).then((value) {
                            if (value != null) {
                              BlocProvider.of<GalleryBloc>(context).add(
                                  UploadImgEvent(
                                      img: value, token: user.token));
                              Navigator.of(context).pop();
                            }
                          });
                        }, 'Camera', Icons.camera, Colors.blue),
                        getAppButton(() {
                          pickImage(ImageSource.gallery).then((value) {
                            if (value != null) {
                              BlocProvider.of<GalleryBloc>(context).add(
                                  UploadImgEvent(
                                      img: value, token: user.token));
                              Navigator.of(context).pop();
                            }
                          });
                        }, 'Gallery', Icons.image, Colors.green),
                      ],
                    ),
                  );
                });
          },
          'Upload',
          Icons.arrow_upward,
          Colors.orange,
        ),
      ],
    );
  }

  Widget imgGridTile(GalleryLoaded state, int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CachedNetworkImage(
        imageUrl: state.galleryModal.imageUrl[index],
        imageBuilder: (context, imageProvider) => Container(
          height: 20.h,
          width: 20.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: CircularProgressIndicator(
            value: progress.progress,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.contain,
      ),
    );
  }

  Future<File?> pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image != null) {
        return File(image.path);
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
    return null;
  }

  ElevatedButton getAppButton(
      void Function() onpress, String label, IconData icon, Color color) {
    return ElevatedButton(
      onPressed: onpress,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: Size(30.w, 5.h),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 2.h,
            width: 4.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: color,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 2.h,
            ),
          ),
          SizedBox(
            width: 3.w,
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
