---
layout: default
title: Mobile Photos
---

<h1 style="text-align: center;">📸 Mobile-Clicks</h1>

<!-- Album selection buttons -->
<div id="album-buttons" style="margin: 1.5rem 0; text-align: center;"></div>


<!-- Landscape media -->
<div class="gallery" id="gallery-landscape"></div>

<!-- Portrait media -->
<div class="gallery" id="gallery-portrait"></div>

<!-- Modal for viewing media -->
<div id="lightbox" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; 
  background:rgba(0,0,0,0.9); z-index:1000; justify-content:center; align-items:center;">
  <span style="position:absolute; top:20px; right:30px; font-size:2rem; color:white; cursor:pointer;" onclick="closeLightbox()">&times;</span>
  <div id="lightbox-content" style="max-width: 90%; max-height: 90%;"></div>
</div>

<!-- Load pre-generated media data -->
<script src="{{ site.baseurl }}/assets/js/meta.js"></script>

<script>
function renderButtons() {
  const container = document.getElementById("album-buttons");
  container.innerHTML = '';
  folderList.forEach(folder => {
    const btn = document.createElement("button");
    btn.textContent = folder;
    btn.onclick = () => {
      filterByFolder(folder);
      highlightButton(btn);
    };
    container.appendChild(btn);
  });
}

function highlightButton(activeButton) {
  const buttons = document.querySelectorAll("#album-buttons button");
  buttons.forEach(btn => btn.style.opacity = "0.6");
  activeButton.style.opacity = "1";
}

function showLightbox(html) {
  const lightbox = document.getElementById("lightbox");
  const content = document.getElementById("lightbox-content");
  content.innerHTML = html;
  lightbox.style.display = "flex";
}

function closeLightbox() {
  document.getElementById("lightbox").style.display = "none";
}

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
      mediaHTML = `<a href="${file.src}" target="_blank"><img src="${file.src}" alt="photo" style="cursor: zoom-in;"></a>`;
    } else if (file.type === "video") {
      // Use fallback download link if playback fails (GitHub Pages limitation)
      mediaHTML = `
  <a href="${file.src}" target="_blank">
    <video muted preload="metadata" style="width: 100%; border-radius: 10px; cursor: pointer;" 
      onerror="this.outerHTML='<a href=\'${file.src}\' class=\'download-button\'>Download Video</a>';">
      <source src="${file.src}" type="video/mp4">
      Your browser does not support the video tag.
    </video>
  </a>
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