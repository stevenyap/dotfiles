#!/bin/bash
set -e

# sudo du -h -d 1 / 2>/dev/null
# Go to XCode > Settings > Components and remove outdated iOS

echo "Cleaning Docker junk files..."
docker system prune -af
docker volume prune -f
docker network prune -f

# https://ajith.blog/xcode-users-can-free-up-space-on-your-mac/
echo "Cleaning Xcode junk files..."
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf ~/Library/Developer/Xcode/Archives
rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport
rm -rf ~/Library/Developer/Xcode/Logs
rm -rf ~/Library/Caches/com.apple.dt.Xcode
xcrun simctl delete unavailable

echo "Cleaning Gradle junk files..."
rm -rf ~/.gradle

echo "Cleaning Yarn and npm caches..."
yarn cache clean
npm cache clean --force

echo "All junk files cleaned up!"
exit 0
