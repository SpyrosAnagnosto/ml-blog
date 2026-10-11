---
layout: default
title: Chem Blog
---

<style>
  .home-hero {
    padding: 20px 0 45px;
    border-bottom: 1px solid #e5e7eb;
  }

  .home-tag {
    font: 700 12px Arial, sans-serif;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    color: #477a92;
  }

  .home-hero h1 {
    font-size: clamp(36px, 6vw, 52px);
    letter-spacing: -1.5px;
    margin: 15px 0;
  }

  .home-intro {
    color: #666;
    font-size: 18px;
    line-height: 1.7;
    max-width: 620px;
  }

  .home-section {
    margin-top: 48px;
  }

  .home-section h2 {
    font-size: 25px;
    margin-bottom: 24px;
  }

  .home-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 18px;
  }

  .home-card {
    display: block;
    padding: 25px;
    border: 1px solid #e5e7eb;
    border-radius: 12px;
    background: #fafafa;
    color: #242424;
    text-decoration: none;
    transition: transform 0.2s, border-color 0.2s;
  }

  .home-card:hover {
    transform: translateY(-3px);
    border-color: #477a92;
    text-decoration: none;
  }

  .home-card h3 {
    font-size: 21px;
    margin: 14px 0 10px;
  }

  .home-card p {
    color: #666;
    font-size: 15px;
    line-height: 1.6;
    margin: 0;
  }

  .home-link {
    display: inline-block;
    margin-top: 20px;
    font: 600 14px Arial, sans-serif;
    color: #256c91;
  }
</style>

<section class="home-hero">
  <span class="home-tag">Machine Learning · Cheminformatics</span>

  <h1>Exploring Machine Learning Through Chemistry.</h1>

  <p class="home-intro">
    A collection of technical notes, experiments, and tutorials
    exploring molecular data, chemical representations,
    and machine learning.
  </p>
</section>

<section class="home-section">
  <h2>Articles</h2>

  <div class="home-grid">

    <a class="home-card"
       href="{{ '/moleculenet-guide.html' | relative_url }}">
      <span class="home-tag">Molecular ML</span>
      <h3>Understanding MoleculeNet</h3>
      <p>
        An introduction to MoleculeNet, its benchmark
        datasets, and molecular property prediction.
      </p>
      <span class="home-link">Read article →</span>
    </a>

    <a class="home-card"
       href="{{ '/esol-audit.html' | relative_url }}">
      <span class="home-tag">Data Exploration</span>
      <h3>Inside ESOL: Exploring Molecular Solubility</h3>
      <p>
        Exploring the Delaney dataset, molecular solubility
        measurements, and the machine learning target.
      </p>
      <span class="home-link">Read article →</span>
    </a>

  </div>
</section>
