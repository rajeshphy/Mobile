---
layout: default
title: Mobile Photos
---

<h1 style="text-align: center;">📸 Mobile-Clicks</h1>

<!-- Album selection buttons -->
<div id="album-buttons" style="margin: 1.5rem 0; text-align: center;"></div>

<!-- Landscape media -->
<h2 style="margin-top: 2rem;">🌄 Landscape</h2>
<div class="gallery" id="gallery-landscape"></div>

<!-- Portrait media -->
<h2 style="margin-top: 2rem;">📱 Portrait</h2>
<div class="gallery" id="gallery-portrait"></div>

<!-- Load pre-generated media data -->
<script src="{{ site.baseurl }}/assets/js/meta.js"></script>

<script>
// Dynamically generate album buttons
function renderButtons() {
  const container = document.getElementById("album-buttons");
  folderList.forEach(folder => {
    const btn = document.createElement("button");
    btn.textContent = folder;
    btn.onclick = () => filterByFolder(folder);
    container.appendChild(btn);
  });
}

// Filter and display media for selected folder
function filterByFolder(folderName) {
  const galleryLandscape = document.getElementById("gallery-landscape");
  const galleryPortrait = document.getElementById("gallery-portrait");
  galleryLandscape.innerHTML = '';
  galleryPortrait.innerHTML = '';

  const filtered = allFiles.filter(file => file.folder === folderName);
  if (filtered.length === 0) {
    galleryLandscape.innerHTML = `<p>No media found in <strong>${folderName}</strong>.</p>`;
    return;
  }

  filtered.forEach(file => {
    const box = document.createElement('div');
    box.className = 'photo-box';

    let mediaHTML = '';

    if (file.type === "image") {
      mediaHTML = `<img src="${file.src}" alt="photo">`;
    } else if (file.type === "video") {
      // Use fallback download link if playback fails (GitHub Pages limitation)
      mediaHTML = `
        <video controls preload="metadata" style="width: 100%; border-radius: 10px;" 
               onerror="this.outerHTML='<a href='${file.src}' class=\'download-button\'>Download Video</a>';">
          <source src="${file.src}" type="video/mp4">
          Your browser does not support the video tag.
        </video>
      `;
    }

    box.innerHTML = `
      ${mediaHTML}
      <div style="margin-top: 0.5rem;">
        <a href="${file.src}" class="download-button" download>Download</a>
      </div>
    `;

    if (file.orientation === "landscape") {
      galleryLandscape.appendChild(box);
    } else {
      galleryPortrait.appendChild(box);
    }
  });
}

// Initialize on page load
renderButtons();
</script>