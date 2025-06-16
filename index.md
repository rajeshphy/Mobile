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

<!-- Lightbox for larger view (optional) -->
<div id="lightbox" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; 
  background:rgba(0,0,0,0.9); z-index:1000; justify-content:center; align-items:center;">
  <span style="position:absolute; top:20px; right:30px; font-size:2rem; color:white; cursor:pointer;" onclick="closeLightbox()">&times;</span>
  <div id="lightbox-content" style="max-width: 90%; max-height: 90%;"></div>
</div>

<!-- Inject Jekyll site.baseurl into JS -->
<script>
  const baseurl = "{{ site.baseurl }}";
</script>

<!-- Load meta.js -->
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

function closeLightbox() {
  document.getElementById("lightbox").style.display = "none";
}

function filterByFolder(folderName) {
  const galleryLandscape = document.getElementById("gallery-landscape");
  const galleryPortrait = document.getElementById("gallery-portrait");
  galleryLandscape.innerHTML = '';
  galleryPortrait.innerHTML = '';

  const filtered = allFiles
    .filter(file => file.folder === folderName)
    .sort((a, b) => a.name?.localeCompare?.(b.name) || 0);

  if (filtered.length === 0) {
    galleryLandscape.innerHTML = `<p>No media found in <strong>${folderName}</strong>.</p>`;
    return;
  }

  filtered.forEach(file => {
    const box = document.createElement('div');
    box.className = 'photo-box';

    const fullSrc = baseurl + file.src;
    let mediaHTML = '';

    if (file.type === "image") {
      mediaHTML = `<a href="${fullSrc}" target="_blank">
        <img src="${fullSrc}" alt="photo" style="cursor: zoom-in;" >
      </a>`;
    } else if (file.type === "video") {
      mediaHTML = `
        <a href="${fullSrc}" target="_blank">
          <video muted preload="metadata" style="width: 100%; border-radius: 10px; cursor: pointer;"
            onerror="this.outerHTML='<a href=\'${fullSrc}\' class=\'download-button\'>Download Video</a>';">
            <source src="${fullSrc}" type="video/mp4">
            Your browser does not support the video tag.
          </video>
        </a>
      `;
    }

    box.innerHTML = `
      ${mediaHTML}
      <div class="center-download">
        <a href="${fullSrc}" class="download-button" download>Download</a>
      </div>
    `;

    if (file.orientation === "landscape") {
      galleryLandscape.appendChild(box);
    } else {
      galleryPortrait.appendChild(box);
    }
  });
}

// Initialize
renderButtons();
</script>