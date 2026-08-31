using System.Windows;
using Launcher.Core;

namespace GameLauncher;

public partial class MainWindow : Window
{
    private readonly LauncherManager _launcherManager;

    public MainWindow()
    {
        InitializeComponent();

        _launcherManager = new LauncherManager();
        _launcherManager.StatusChanged += OnLauncherStatusChanged;

        TxtVersion.Text = $"Версия: {_launcherManager.Version}";
        
        // Perform initial check on startup
        _ = _launcherManager.CheckUpdatesAsync();
    }

    private void OnLauncherStatusChanged(LauncherStatus status, string message)
    {
        Dispatcher.Invoke(() =>
        {
            TxtStatus.Text = $"Статус: {message}";

            switch (status)
            {
                case LauncherStatus.Ready:
                    BtnPlay.IsEnabled = true;
                    StatusIndicator.Fill = new System.Windows.Media.SolidColorBrush(System.Windows.Media.Color.FromRgb(76, 175, 80)); // Green
                    break;
                case LauncherStatus.Checking:
                case LauncherStatus.Downloading:
                case LauncherStatus.Launching:
                    BtnPlay.IsEnabled = false;
                    StatusIndicator.Fill = new System.Windows.Media.SolidColorBrush(System.Windows.Media.Color.FromRgb(255, 193, 7)); // Yellow
                    break;
                case LauncherStatus.Error:
                case LauncherStatus.Disabled:
                    BtnPlay.IsEnabled = false;
                    StatusIndicator.Fill = new System.Windows.Media.SolidColorBrush(System.Windows.Media.Color.FromRgb(244, 67, 54)); // Red
                    break;
            }
        });
    }

    private async void BtnPlay_Click(object sender, RoutedEventArgs e)
    {
        await _launcherManager.LaunchGameAsync();
    }

    private void BtnFolder_Click(object sender, RoutedEventArgs e)
    {
        _launcherManager.OpenGameFolder();
    }

    private void BtnSite_Click(object sender, RoutedEventArgs e)
    {
        _launcherManager.OpenSite("https://projero.vercel.app");
    }
}
