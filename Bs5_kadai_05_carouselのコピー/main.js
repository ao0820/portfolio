console.log("main.js!!");

const carouselObj = new bootstrap.carousel("#carouselExample",{
    interval:1000,
});

document.addEventListener('DOMContentLoaded', function () {
    const carousel = document.querySelector('#carouselIndicators');
    const bsCarousel = new bootstrap.Carousel(carousel);
    const pauseBtn = document.getElementById('pauseBtn');
    const playBtn = document.getElementById('playBtn');
    const progressBar = document.getElementById('carouselProgress');
    const thumbs = document.querySelectorAll('.thumbnail-indicators img');
  
    pauseBtn.onclick = () => bsCarousel.pause();
    playBtn.onclick = () => bsCarousel.cycle();
  
    carousel.addEventListener('slide.bs.carousel', e => {
      const total = document.querySelectorAll('.carousel-item').length;
      const percent = (e.to / (total - 1)) * 100;
      progressBar.style.width = `${percent}%`;
      thumbs.forEach(img => img.classList.remove('active'));
      if (thumbs[e.to]) thumbs[e.to].classList.add('active');
    });
  });