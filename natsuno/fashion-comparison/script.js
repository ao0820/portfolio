document.addEventListener('DOMContentLoaded', () => {
    
    // Default URLs
    const DEFAULT_LEFT = "https://www.darich.shop/";
    const DEFAULT_RIGHT = "https://www.uniqlo.com/jp/ja/";

    // Elements
    const urlLeftInput = document.getElementById('url-left');
    const urlRightInput = document.getElementById('url-right');
    const iframeLeft = document.getElementById('frame-left');
    const iframeRight = document.getElementById('frame-right');
    const linkLeft = document.querySelector('#pane-left .open-tab-btn');
    const linkRight = document.querySelector('#pane-right .open-tab-btn');
    const extLinkLeft = document.querySelector('#url-left + .external-link-icon');
    const extLinkRight = document.querySelector('#url-right + .external-link-icon');
    const resetBtn = document.getElementById('reset-btn');

    // Helper to validate/format URL
    function formatUrl(url) {
        if (!url) return '';
        if (!url.startsWith('http')) return 'https://' + url;
        return url;
    }

    // Function to update iframes
    function updateFrames() {
        const leftUrl = formatUrl(urlLeftInput.value);
        const rightUrl = formatUrl(urlRightInput.value);

        if (iframeLeft.src !== leftUrl) {
            iframeLeft.src = leftUrl;
            linkLeft.href = leftUrl; // Update fallback link
            extLinkLeft.href = leftUrl;
        }

        if (iframeRight.src !== rightUrl) {
            iframeRight.src = rightUrl;
            linkRight.href = rightUrl; // Update fallback link
            extLinkRight.href = rightUrl;
        }
    }

    // Event Listeners for inputs (Enter key)
    urlLeftInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') updateFrames();
    });

    urlRightInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') updateFrames();
    });

    // Reset Button
    resetBtn.addEventListener('click', () => {
        urlLeftInput.value = DEFAULT_LEFT;
        urlRightInput.value = DEFAULT_RIGHT;
        updateFrames();
    });

    // Initial load check
    updateFrames();

    // Reload helper
    window.reloadIframe = (id) => {
        const iframe = document.getElementById(id);
        iframe.src = iframe.src;
    };
});
