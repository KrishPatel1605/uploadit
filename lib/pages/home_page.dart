import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:uploadit/auth/auth_service.dart';
import 'package:uploadit/utils/count_helper.dart';
import 'package:uploadit/utils/routes.dart';
import 'package:uploadit/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authService = AuthService();

  final List<_TileData> _tiles = const [
    _TileData(
      title: 'Upload',
      icon: Icons.cloud_upload,
      route: Routes.uploadRoute,
    ),
    _TileData(
      title: 'My Uploads',
      icon: Icons.folder,
      route: Routes.myUploadsRoute,
    ),
    _TileData(
      title: 'My Downloads',
      icon: Icons.download,
      route: Routes.myDownloadsRoute,
    ),
    _TileData(
      title: 'Download by Code',
      icon: Icons.key,
      route: Routes.downloadByCodeRoute,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed:
                () => Navigator.pushNamed(context, Routes.downloadByQRRoute),
            icon: Icon(Icons.qr_code_scanner),
            tooltip: 'Scan QR',
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FutureBuilder<UploadDownloadCounts>(
              future: getCountsForCurrentUser(), // see helper below
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final c = snap.data!;
                final total = c.uploads + c.downloads;
                if (total == 0) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: Text('No uploads or downloads yet')),
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 4,
                          centerSpaceRadius: 40,
                          borderData: FlBorderData(show: false),
                          sections: [
                            PieChartSectionData(
                              value: c.uploads.toDouble(),
                              title: '',
                              // title: '${c.uploads}',
                              color: Colors.purpleAccent,
                            ),
                            PieChartSectionData(
                              value: c.downloads.toDouble(),
                              title: '',
                              // title: '${c.downloads}',
                              color: Colors.purple,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _LegendDot(color: Colors.purpleAccent),
                        const SizedBox(width: 4),
                        const Text('Uploads'),
                        const SizedBox(width: 16),
                        _LegendDot(color: Colors.purple),
                        const SizedBox(width: 4),
                        const Text('Downloads'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.cloud_upload,
                              color: Colors.purpleAccent,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Uploads: ${c.uploads}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 20),
                            Icon(Icons.download, color: Colors.purple),
                            const SizedBox(width: 8),
                            Text(
                              'Downloads: ${c.downloads}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: _tiles.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final tile = _tiles[index];
                  return _DashboardCard(tile: tile);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TileData {
  final String title;
  final IconData icon;
  final String route;
  const _TileData({
    required this.title,
    required this.icon,
    required this.route,
  });
}

class _DashboardCard extends StatelessWidget {
  final _TileData tile;
  const _DashboardCard({required this.tile});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.pushNamed(context, tile.route),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(tile.icon, size: 48),
              const SizedBox(height: 12),
              Text(tile.title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
