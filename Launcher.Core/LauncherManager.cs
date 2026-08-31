namespace Launcher.Core;

public enum LauncherStatus
{
    Ready,
    Checking,
    Downloading,
    Launching,
    Error,
    Disabled
}

public class LauncherManager
{
    public string Version => "0.1.0";
    
    public event Action<LauncherStatus, string>? StatusChanged;

    private LauncherStatus _currentStatus = LauncherStatus.Ready;
    public LauncherStatus CurrentStatus
    {
        get => _currentStatus;
        private set
        {
            _currentStatus = value;
            OnStatusChanged(_currentStatus, GetStatusDescription(_currentStatus));
        }
    }

    public LauncherManager()
    {
        // Initial state
    }

    public async Task CheckUpdatesAsync()
    {
        CurrentStatus = LauncherStatus.Checking;
        await Task.Delay(1500); // Simulate check
        CurrentStatus = LauncherStatus.Ready;
    }

    public async Task LaunchGameAsync()
    {
        if (CurrentStatus == LauncherStatus.Disabled || CurrentStatus == LauncherStatus.Error)
            return;

        CurrentStatus = LauncherStatus.Launching;
        await Task.Delay(1000); // Simulate game start

        try
        {
            string gameBatPath = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "game.bat");
            if (System.IO.File.Exists(gameBatPath))
            {
                System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo
                {
                    FileName = gameBatPath,
                    UseShellExecute = true
                });
            }
        }
        catch
        {
            CurrentStatus = LauncherStatus.Error;
            return;
        }

        CurrentStatus = LauncherStatus.Ready;
    }

    public void OpenGameFolder()
    {
        string path = AppDomain.CurrentDomain.BaseDirectory;
        try
        {
            System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo
            {
                FileName = path,
                UseShellExecute = true,
                Verb = "open"
            });
        }
        catch
        {
            CurrentStatus = LauncherStatus.Error;
        }
    }

    public void OpenSite(string url = "https://example.com")
    {
        try
        {
            System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo
            {
                FileName = url,
                UseShellExecute = true
            });
        }
        catch
        {
            CurrentStatus = LauncherStatus.Error;
        }
    }

    private string GetStatusDescription(LauncherStatus status) => status switch
    {
        LauncherStatus.Ready => "Готово к запуску",
        LauncherStatus.Checking => "Проверка обновлений...",
        LauncherStatus.Downloading => "Загрузка файлов...",
        LauncherStatus.Launching => "Запуск игры...",
        LauncherStatus.Error => "Ошибка запуска / файла",
        LauncherStatus.Disabled => "Недоступно",
        _ => "Неизвестно"
    };

    protected virtual void OnStatusChanged(LauncherStatus status, string message)
    {
        StatusChanged?.Invoke(status, message);
    }
}
