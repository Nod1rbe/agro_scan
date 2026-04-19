import 'package:agro_scan/app/theme_scope.dart';
import 'package:agro_scan/features/home/presentation/cubit/home_cubit.dart';
import 'package:agro_scan/features/home/presentation/widgets/progress_page.dart';
import 'package:agro_scan/features/history/presentation/pages/history_page.dart';
import 'package:agro_scan/features/scan/data/repositories/scan_repository.dart';
import 'package:agro_scan/features/scan/presentation/cubit/scan_cubit.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../scan/presentation/pages/camera_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const _HomeShell(),
    );
  }
}

class _HomeShell extends StatefulWidget {
  const _HomeShell();

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  void _cycleTheme(BuildContext context) {
    final scope = ThemeScope.of(context);
    final next = switch (scope.themeMode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    scope.setThemeMode(next);
  }

  IconData _themeIcon(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.dark => Icons.light_mode_rounded,
      ThemeMode.light => Icons.dark_mode_rounded,
      ThemeMode.system => Icons.brightness_auto_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final themeMode = ThemeScope.of(context).themeMode;

    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) async {
        if (state is HomeOpenCamera) {
          final cameras = await availableCameras();
          if (!context.mounted) return;
          await Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => CameraPage(cameras: cameras)),
          );
          if (context.mounted) context.read<HomeCubit>().reset();
        } else if (state is HomeOpenGallery) {
          final image = await ImagePicker().pickImage(source: ImageSource.gallery);
          if (image == null) return;
          if (!context.mounted) return;
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => BlocProvider(
                create: (_) => ScanCubit(ScanRepository()),
                child: ProgressPage(imagePath: image.path),
              ),
            ),
          );
          if (context.mounted) context.read<HomeCubit>().reset();
        }
      },
      child: Builder(
        builder: (context) {
          final cubit = context.read<HomeCubit>();
          return Scaffold(
            appBar: AppBar(
              title: const Text('AgroScan'),
              actions: [
                IconButton(
                  tooltip: 'Tema',
                  onPressed: () => _cycleTheme(context),
                  icon: Icon(_themeIcon(themeMode)),
                ),
              ],
            ),
            body: _HomeTabBody(
              cs: cs,
              cubit: cubit,
              onOpenHistory: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const HistoryPage()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _HomeTabBody extends StatelessWidget {
  const _HomeTabBody({
    required this.cs,
    required this.cubit,
    required this.onOpenHistory,
  });

  final ColorScheme cs;
  final HomeCubit cubit;
  final VoidCallback onOpenHistory;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            cs.surface,
            Color.lerp(cs.surface, cs.primary, 0.07)!,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/logo.svg', height: 72),
                        const SizedBox(height: 12),
                        Text(
                          'AgroScan',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontFamily: 'AlfaSlabOne',
                                color: cs.onSurface,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'O‘simliklaringiz sog‘lig‘ini sun’iy intellekt bilan nazorat qiling',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: cs.onSurfaceVariant,
                                fontFamily: 'Alice',
                                height: 1.35,
                              ),
                        ),
                        const SizedBox(height: 28),
                        _ActionTile(
                          title: 'Cameradan rasmga olish',
                          subtitle: 'Kamera orqali o‘simlik tasvirini olish',
                          iconPath: 'assets/icons/camera.svg',
                          onTap: cubit.openCamera,
                        ),
                        const SizedBox(height: 12),
                        _ActionTile(
                          title: 'Galereyadan rasm yuklash',
                          subtitle: 'Telefoningizdan rasmni tanlang',
                          iconPath: 'assets/icons/download.svg',
                          onTap: cubit.openGallery,
                        ),
                        const SizedBox(height: 12),
                        _ActionTile(
                          title: 'History',
                          subtitle: 'Oldingi tahlillar tarixini ko‘rish',
                          iconData: Icons.history_rounded,
                          onTap: onOpenHistory,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                'Aniq tahlil uchun zararlangan bargning sifatli fotosuratini oling',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontFamily: 'Alice',
                    ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.subtitle,
    this.iconPath,
    this.iconData,
    required this.onTap,
  }) : assert(iconPath != null || iconData != null);

  final String title;
  final String subtitle;
  final String? iconPath;
  final IconData? iconData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surfaceContainerLow,
      elevation: 0,
      shadowColor: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        splashColor: cs.primary.withValues(alpha: 0.12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: iconPath != null
                    ? SvgPicture.asset(iconPath!, width: 28, height: 28)
                    : Icon(iconData, size: 28, color: cs.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontFamily: 'AlfaSlabOne',
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontFamily: 'Alice',
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: cs.outline),
            ],
          ),
        ),
      ),
    );
  }
}
