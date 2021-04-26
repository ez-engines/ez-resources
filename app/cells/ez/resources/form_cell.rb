# frozen_string_literal: true

module Ez
  module Resources
    class FormCell < ApplicationCell
      form

      def form_header_label
        if model.data.new_record?
          "#{t('actions.new')} #{model.resource_name.downcase}"
        else
          "#{t('actions.edit')} #{model.data.public_send(model.resource_label)} #{model.resource_name.downcase}"
        end
      end

      def readonly?
        @readonly ||= if model.data.new_record?
                        !Ez::Resources::Manager::Hooks.can?(:can_create?, model, model.data)
                      else
                        !Ez::Resources::Manager::Hooks.can?(:can_update?, model, model.data)
                      end
      end

      def submit_button_text
        if model.data.new_record?
          t('actions.create')
        else
          t('actions.update')
        end
      end
    end
  end
end
