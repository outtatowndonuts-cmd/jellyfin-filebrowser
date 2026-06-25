# Jellyfin + File Browser on Railway

A single Docker container running Jellyfin (media server) and File Browser (file management) with persistent storage.

## Features

- **Jellyfin**: Media streaming server with user management
- **File Browser**: Browser-based file upload, download, and management
- **ffmpeg**: Video transcoding support
- **Supervisor**: Process management for both services
- **Persistent Volume**: Single Railway volume for media, config, and cache

## Ports

- `8096`: Jellyfin (media streaming)
- `8080`: File Browser (file management)

## Volume Structure

Single 1 TB Railway volume mounted to `/data`:

```
/data
├── media/          - Your media library (movies, TV, music, photos)
├── config/         - Jellyfin and File Browser configuration
└── cache/          - Jellyfin transcoding cache
```

## Setup

1. Deploy to Railway with a persistent 1 TB volume
2. Configure domains:
   - `media.yourdomain.com` → Jellyfin (port 8096)
   - `files.yourdomain.com` → File Browser (port 8080)
3. Access File Browser and upload media to `/data/media`
4. Jellyfin will automatically scan and index new files

## File Browser Admin

Default credentials:
- Username: `Admin`
- Password: `Password123!`

Change these immediately after first login.

## Jellyfin Setup

1. Access Jellyfin at `media.yourdomain.com`
2. Complete the initial setup wizard
3. Create user accounts for family members
4. Configure library paths:
   - Movies: `/data/media/Movies`
   - TV Shows: `/data/media/TV`
   - Music: `/data/media/Music`
   - Photos: `/data/media/Photos`
5. Enable automatic library scanning

## Transcoding Notes

Jellyfin will transcode video for devices that don't support direct playback. This uses CPU. For best performance:
- Ensure devices support direct playback (Roku, Fire TV, Android TV, modern smart TVs)
- Monitor CPU usage in Railway dashboard
- Consider upgrading Railway plan if transcoding becomes expensive

## Troubleshooting

Check logs in Railway dashboard:
- Jellyfin: `/var/log/supervisor/jellyfin.out.log`
- File Browser: `/var/log/supervisor/filebrowser.out.log`

