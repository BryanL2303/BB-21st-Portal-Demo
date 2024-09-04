module Api
	class DemoAdminController < ApplicationController
        protect_from_forgery with: :null_session

        def getTableNames
            table_names = ActiveRecord::Base.connection.tables
            table_names.delete("schema_migrations")
            table_names.delete("ar_internal_metadata")
            render json: table_names
        end

        def getTable
            data = ActiveRecord::Base.connection.exec_query("SELECT * FROM #{params[:table_name]} ORDER BY id ASC")
            columns = ActiveRecord::Base.connection.columns(params[:table_name])
            render json: {data: data, columns: columns}
        end

        def addData
            model_class = params[:table_name].classify.safe_constantize

            if model_class
                new_entry = model_class.new
                params[:columns].each do |column|
                    new_entry[column] = params[:data][column] if new_entry.respond_to?(column)
                end
                new_entry.save
            end

            data = ActiveRecord::Base.connection.exec_query("SELECT * FROM #{model_class.table_name} ORDER BY id ASC")
            columns = ActiveRecord::Base.connection.columns(model_class.table_name)
            
            render json: { data: data, columns: columns }
        end

        def updateData
            data = ActiveRecord::Base.connection.exec_query("SELECT * FROM #{params[:table_name]} WHERE id = #{params[:id]}").first
            if data.any?
                params[:columns].each do |column|
                    data[column] = params[:data][column] if params[:data][column].present?
                end
                
                set_clause = data.map { |key, value| "#{key} = #{ActiveRecord::Base.connection.quote(value)}" }.join(", ")
                update_query = "UPDATE #{ActiveRecord::Base.connection.quote_table_name(params[:table_name])} SET #{set_clause} WHERE id = #{ActiveRecord::Base.connection.quote(params[:id])}"
                ActiveRecord::Base.connection.execute(update_query)
            end

                data = ActiveRecord::Base.connection.exec_query("SELECT * FROM #{params[:table_name]} ORDER BY id ASC")
                columns = ActiveRecord::Base.connection.columns(params[:table_name])
                render json: {data: data, columns: columns}
        end

        def deleteData
            data = ActiveRecord::Base.connection.exec_query("SELECT * FROM #{params[:table_name]} WHERE id = #{params[:id]}").first

            if data.any?
                ActiveRecord::Base.connection.execute("DELETE FROM #{params[:table_name]} WHERE id = #{params[:id]}")
            end

            data = ActiveRecord::Base.connection.exec_query("SELECT * FROM #{params[:table_name]} ORDER BY id ASC")
            columns = ActiveRecord::Base.connection.columns(params[:table_name])
            render json: {data: data, columns: columns}
        end

        def getTables
            tables = {}
            columns = {}
            table_names = ActiveRecord::Base.connection.tables
            table_names.each do |table_name|
                next if ['schema_migrations', 'ar_internal_metadata'].include?(table_name)
                tables[table_name] = ActiveRecord::Base.connection.exec_query("SELECT * FROM #{table_name}")
                columns[table_name] = ActiveRecord::Base.connection.columns(table_name)
            end

            table_names.delete("schema_migrations")
            table_names.delete("ar_internal_metadata")

            render json: {table_names: table_names, tables: tables, columns: columns}
        end
    end
end