import 'package:flutter/material.dart';
import '../../common/widgets/avatar_widget.dart';
import '../../common/widgets/stat_card.dart';
import '../../common/widgets/custom_bottom_nav_bar.dart';

/// Profile Screen for the E-Bike Tracking App.
/// Displays user profile, stats, account options, and activities.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 3; // Profile tab is active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildProfileHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsSection(),
                    const SizedBox(height: 24),
                    _buildMyAccountSection(),
                    const SizedBox(height: 24),
                    _buildActivitiesSection(),
                    const SizedBox(height: 24),
                    _buildSettingsAndLogout(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom navigation is now handled by MainNavigationScreen
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black,
      child: Row(
        children: [
          AvatarWidget(
            imageUrl: null, // Use placeholder instead of non-existent URL
            radius: 40,
            showEdit: true,
            onEdit: () {
              // TODO: Handle profile edit
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Andrew Garfield',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Andrewgarfielf@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Icons.pedal_bike,
            value: '120',
            label: 'Total Rides',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: Icons.equalizer,
            value: '560Km',
            label: 'Total Distance',
            accentColor: const Color(0xFFD4FF3F),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: Icons.speed,
            value: '22 km/h',
            label: 'Avg Speed',
          ),
        ),
      ],
    );
  }

  Widget _buildMyAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildListTile(
          icon: Icons.pedal_bike,
          title: 'E-bikes details',
          onTap: () {
            // TODO: Navigate to e-bikes details
          },
        ),
        _buildListTile(
          icon: Icons.insights,
          title: 'Ride Insights',
          onTap: () {
            // TODO: Navigate to ride insights
          },
        ),
        _buildListTile(
          icon: Icons.credit_card,
          title: 'Subscription & Plans Card',
          onTap: () {
            // TODO: Navigate to subscription
          },
        ),
      ],
    );
  }

  Widget _buildActivitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activities',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildListTile(
          icon: Icons.history,
          title: 'Ride History',
          onTap: () {
            // TODO: Navigate to ride history
          },
        ),
        _buildListTile(
          icon: Icons.favorite,
          title: 'Saved Routes',
          onTap: () {
            // TODO: Navigate to saved routes
          },
        ),
        _buildListTile(
          icon: Icons.refresh,
          title: 'Recent Trips',
          onTap: () {
            // TODO: Navigate to recent trips
          },
        ),
      ],
    );
  }

  Widget _buildSettingsAndLogout() {
    return Column(
      children: [
        _buildListTile(
          icon: Icons.settings,
          title: 'Settings',
          onTap: () {
            // TODO: Navigate to settings
          },
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Handle logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
