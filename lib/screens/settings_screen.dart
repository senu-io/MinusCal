import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  final StorageService storageService;
  final VoidCallback onPantryReset;

  const SettingsScreen({
    super.key,
    required this.storageService,
    required this.onPantryReset,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isTestingKey = false;
  String? _testResult;
  bool _testSuccess = false;

  @override
  void initState() {
    super.initState();
    final savedKey = widget.storageService.getApiKey();
    if (savedKey != null) {
      _apiKeyController.text = savedKey;
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveKey() async {
    final key = _apiKeyController.text.trim();
    if (key.isEmpty) {
      await widget.storageService.clearApiKey();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API key cleared')),
      );
    } else {
      await widget.storageService.saveApiKey(key);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API key saved')),
      );
    }
    setState(() {});
  }

  Future<void> _testApiKey() async {
    final key = _apiKeyController.text.trim();
    if (key.isEmpty) {
      setState(() {
        _testResult = 'Enter an API key to test';
        _testSuccess = false;
      });
      return;
    }

    setState(() {
      _isTestingKey = true;
      _testResult = null;
    });

    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$key',
      );
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: '{"contents":[{"parts":[{"text":"ping"}]}]}',
      );

      if (res.statusCode == 200) {
        setState(() {
          _testSuccess = true;
          _testResult = 'Connection verified. Google Gemini 2.0 Flash is ready.';
        });
        await widget.storageService.saveApiKey(key);
      } else {
        setState(() {
          _testSuccess = false;
          _testResult = 'Validation failed (code ${res.statusCode}). Check key permissions.';
        });
      }
    } catch (e) {
      setState(() {
        _testSuccess = false;
        _testResult = 'Connection error: $e';
      });
    } finally {
      if (mounted) setState(() => _isTestingKey = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Section: API Key
          const Text(
            'Google Gemini API',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.text,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add your free API key from Google AI Studio (aistudio.google.com) for real-time model requests.',
            style: TextStyle(fontSize: 14, color: AppTheme.textQuiet, height: 1.4),
          ),
          const SizedBox(height: 16),

          // Input with persistent label above
          const Text(
            'API key',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textQuiet),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _apiKeyController,
            obscureText: true,
            style: const TextStyle(color: AppTheme.text, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Paste key here',
              hintStyle: const TextStyle(color: AppTheme.textMuted),
              filled: true,
              fillColor: AppTheme.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.line),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.line),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton(
                onPressed: _isTestingKey ? null : _testApiKey,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.line),
                  foregroundColor: AppTheme.text,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: _isTestingKey
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Test connection'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _saveKey,
                child: const Text('Save key'),
              ),
            ],
          ),
          if (_testResult != null) ...[
            const SizedBox(height: 12),
            Text(
              _testResult!,
              style: TextStyle(
                fontSize: 13,
                color: _testSuccess ? AppTheme.pop : AppTheme.support,
              ),
            ),
          ],

          const SizedBox(height: 32),
          const Divider(height: 1, color: AppTheme.line),
          const SizedBox(height: 24),

          // Section: Data & Storage
          const Text(
            'Data',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.text,
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Reset kitchen inventory', style: TextStyle(color: AppTheme.text, fontSize: 15)),
            subtitle: const Text('Restores original basic pantry checklist', style: TextStyle(fontSize: 13, color: AppTheme.textQuiet)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textMuted),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppTheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppTheme.line),
                  ),
                  title: const Text('Reset inventory?'),
                  content: const Text('This resets your kitchen checklist to the default pantry items and removes custom additions.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel', style: TextStyle(color: AppTheme.textQuiet)),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.support,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Reset inventory'),
                    ),
                  ],
                ),
              );

              if (confirm == true && mounted) {
                await widget.storageService.resetPantryToDefaults();
                widget.onPantryReset();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kitchen inventory reset to defaults')),
                );
              }
            },
          ),

          const SizedBox(height: 48),
          Center(
            child: Text(
              'MinusCal 1.0.0',
              style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
