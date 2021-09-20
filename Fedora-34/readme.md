# Fedora 34

## Nereye Klasörü koymalıyız?
Normal kullanıcı hesabınız home klasörün içinde tüm dosyalar ve klasörler ile birlikte Fedora-34 adlı klasörün içinde olması gerek
```bash
** home
* {USER}
-- Fedora-34
- appimages
- bundles
- rpms
- runs
- readme.md
- setup.sh
```

`--snap` - snapd/snap da yükler

### Örnek

```bash
sudo chmod +x ./setup.sh
sudo ./setup.sh --snap
```
> Snap Yüklenmesin diyor iseniz

```bash
sudo chmod +x ./setup.sh
sudo ./setup.sh
```