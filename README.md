
## Setup

1. Deploy to Railway with a persistent volume (1 TB recommended for < 1 TB media)
2. Configure domains:
   - `media.yourdomain.com` → Jellyfin (port 8096)
   - `files.yourdomain.com` → File Browser (port 8080)
3. Access File Browser and upload media
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
4. Configure library paths to `/media/Movies`, `/media/TV`, etc.
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
