import 'package:agro_scan/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../main.dart';
import '../../../scan/presentation/pages/camera_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) async {
          if (state is HomeNavigateToScan) {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => CameraPage(cameras: cameras)));
            if (context.mounted) context.read<HomeCubit>().reset();
          }
        },
        child: Builder(
          builder: (context) {
            final cubit = context.read<HomeCubit>();
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          spacing: 8,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/logo.svg'),
                            const Text('AgroScan', style: TextStyle(fontFamily: 'AlfaSlabOne', fontSize: 28)),
                            const Text(
                              'O‘simliklaringiz sog‘lig‘ini sun’iy intellekt bilan nazorat qiling',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Alice'),
                            ),
                            const SizedBox(height: 8),
                            _actionButton(
                              title: 'Rasmga olish',
                              subtitle: 'Kamera orqali o‘simlik tasvirini olish',
                              iconPath: 'assets/icons/camera.svg',
                              onTap: cubit.openCamera,
                            ),
                            const SizedBox(height: 8),
                            _actionButton(
                              title: 'Galereyadan yuklash',
                              subtitle: 'Telefoningizdan rasmni tanlang',
                              iconPath: 'assets/icons/download.svg',
                              onTap: cubit.openGallery,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Text(
                      'Aniq tahlil uchun zararlangan bargning sifatli fotosuratini oling',
                      style: TextStyle(fontFamily: 'Alice'),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _actionButton({
    required String title,
    required String subtitle,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: const Color(0xFF00C950),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF00C950)),
        ),
        child: Row(
          spacing: 12,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFDBFCE7)),
              child: SvgPicture.asset(iconPath),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontFamily: 'AlfaSlabOne')),
                  Text(
                    subtitle,
                    style: const TextStyle(fontFamily: 'Alice'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
