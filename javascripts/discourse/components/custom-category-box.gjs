import Component from "@glimmer/component";
import { htmlSafe } from "@ember/template";
import CategoriesBoxesTopic from "discourse/components/categories-boxes-topic";
import CategoryTitleBefore from "discourse/components/category-title-before";
import CdnImg from "discourse/components/cdn-img";
import icon from "discourse/helpers/d-icon";
import { i18n } from "discourse-i18n";
import number  from "discourse/helpers/number";


function hexToRgb(hex) {
  // Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
  hex = hex.replace(
    /^#?([a-f\d])([a-f\d])([a-f\d])$/i,
    (_, r, g, b) => r + r + g + g + b + b
  );

  const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result
    ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16),
      }
    : null;
}

function labelStyle(color) {
  const styleString = `
    border-left: 4px solid #${color};
  `;

  return htmlSafe(styleString.trim());
}

function elementOf(obj) {
    return JSON.stringify(obj);
}

export default class CustomCategoryBox extends Component {

  get hasSubcategories() {
      return (this.args.category.subcategories || []).length > 0;
  }

  get color() {
    return hexToRgb(this.args.category.color);
  }

  get bgIndex() {
    return Math.floor(Math.random() * 4);
  }

  get backgroundImageUrl() {
    const bgKey = `${settings.category_background}-${this.bgIndex}`;
    return settings.theme_uploads[bgKey];
  }

  styleAttribute() {
    const { color } = this;

    if (!this.hasSubcategories || !color) {
      return null;
    }

    const { r, g, b } = color;
    const borderColor = this.args.category.color;
    const bgUrl = this.backgroundImageUrl;

    const styleString = `
      border: 1px solid #${borderColor};
    `;

    return htmlSafe(styleString.trim());
  }


  <template>
    {{#if this.hasSubcategories }}
      <div
        class="custom-category {{if @category.isMuted '--muted'}}"
      >
        <section class="custom-category-section">
          <div class="vbulletin-directory-header" href={{@category.url}}>
            {{#unless @category.isMuted}}
              {{#if @category.uploaded_logo.url}}
                <CdnImg
                  @src={{@category.uploaded_logo.url}}
                  @width={{@category.uploaded_logo.width}}
                  @height={{@category.uploaded_logo.height}}
                  class="logo"
                />
              {{/if}}
            {{/unless}}

            <h2 id="custom-category-title">
              <CategoryTitleBefore @category={{@category}} />
              {{#if @category.read_restricted}}
                {{icon "lock"}}
              {{/if}}
              {{@category.name}}
            </h2>
          </div>
          <div class="vbulletin-table">
          <div class="vbulletin-header">
            <p>{{i18n (themePrefix "subcategory.title") }}</p>
            <p>{{i18n "directory.topic_count"}}</p>
            <p>{{i18n "directory.post_count"}}</p>
          </div>
          {{#unless @category.isMuted}}
            <div class="custom-subcategories">
              {{#if @category.subcategories}}
                <ul>
                  {{#each @category.subcategories as |sub|}}
                    <li>
                    <a class="subcategory-data-row" href={{sub.url}}>
                      <div>
                      <span class="title">{{sub.name}}</span><br/>
                      <span class="subtitle">{{sub.description_text}}</span>
                      </div>
                      <span class="num">{{number sub.topic_count }}</span>
                      <span class="num">{{number sub.post_count }}</span>
                    </a>
                    </li>
                  {{/each}}
                </ul>
              {{/if}}
            </div>
          {{/unless}}
          </div>
        </section>
      </div>
    {{/if}}
  </template>
}
