#!/usr/bin/env node

/**
 * Stitch Design Asset Downloader for Health2U
 *
 * Downloads 8 screen designs from the Stitch project using the SDK.
 *
 * Usage:
 *   STITCH_API_KEY=your_key node download-stitch-assets.js
 */

import { stitch } from "@google/stitch-sdk";
import { execSync } from "child_process";
import { mkdirSync, existsSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));

const PROJECT_ID = "4316282056652774057";

const SCREENS = [
  { id: "8daf7fa7ee8245f9ac14e897ae4f9914", name: "dashboard" },
  { id: "753b673616774feaafd6fa855bacaf99", name: "ai-upload-processing" },
  { id: "a953f4d1d29e4083960125c0b4384177", name: "exams" },
  { id: "e06d2a0feccc4b81ac13d05a628763a0", name: "insights" },
  {
    id: "asset-stub-assets-e59fec01f99a454b809ebd6013fd7a6e-1774120825936",
    name: "design-system",
  },
  { id: "340ec2c957c64bc7a55d49b92ec861b2", name: "user-profile" },
  { id: "7536d063fa1944fa816d05ea36ad1805", name: "edit-profile" },
  { id: "9595423fc1644b04a3b4f447f4dea1ca", name: "settings" },
];

const IMAGES_DIR = join(__dirname, "images");
const CODE_DIR = join(__dirname, "code");

for (const dir of [IMAGES_DIR, CODE_DIR]) {
  if (!existsSync(dir)) mkdirSync(dir, { recursive: true });
}

async function main() {
  console.log("=== Health2U Stitch Asset Downloader ===\n");

  if (!process.env.STITCH_API_KEY) {
    console.error("ERROR: STITCH_API_KEY environment variable is not set.");
    process.exit(1);
  }

  const project = stitch.project(PROJECT_ID);
  let success = 0;
  let failed = 0;

  for (const screen of SCREENS) {
    try {
      console.log(`Fetching: ${screen.name} (${screen.id})...`);
      const s = await project.getScreen(screen.id);

      const imageUrl = await s.getImage();
      if (imageUrl) {
        const imgPath = join(IMAGES_DIR, `${screen.name}.png`);
        console.log(`  Downloading image...`);
        execSync(`curl -sL -o "${imgPath}" "${imageUrl}"`);
        console.log(`  ✓ ${screen.name}.png`);
      }

      const htmlUrl = await s.getHtml();
      if (htmlUrl) {
        const htmlPath = join(CODE_DIR, `${screen.name}.html`);
        console.log(`  Downloading HTML...`);
        execSync(`curl -sL -o "${htmlPath}" "${htmlUrl}"`);
        console.log(`  ✓ ${screen.name}.html`);
      }

      success++;
    } catch (err) {
      console.error(`  ✗ ${screen.name}: ${err.message}`);
      failed++;
    }
    console.log();
  }

  console.log(`=== Done: ${success} succeeded, ${failed} failed ===`);
}

main().catch((err) => {
  console.error("Fatal:", err);
  process.exit(1);
});
